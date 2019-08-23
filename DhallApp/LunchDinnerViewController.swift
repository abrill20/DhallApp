//
//  LunchDinnerViewController.swift
//  DhallApp
//
//  Created by Aaron Brill on 8/22/19.
//  Copyright © 2019 Aaron Brill. All rights reserved.
//

import UIKit
import FirebaseDatabase

class LunchDinnerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var lunchFoods = [Food]()
    var dinnerFoods = [Food]()
    lazy var dataToDisplay = lunchFoods
    var date: Date?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataToDisplay.filter { (food: Food) in
            return food.station?.rawValue == section
        }.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let correctStation = dataToDisplay.filter { (food: Food) in
            return food.station?.rawValue == indexPath.section
        }
        cell.textLabel?.text = correctStation[indexPath.row].name
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Food.Station.allCases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Emily's Garden"
        case 1:
            return "Diner"
        case 2:
            return "Global"
        default:
            return "Unknown"
        }
    }
    
    @IBAction func segmentedControlTapped(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            dataToDisplay = lunchFoods
        default:
            dataToDisplay = dinnerFoods
        }
        
        tableView.reloadData()
    }
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchMeals(withReference: Database.database().reference())
        
        print(lunchFoods.count)

    }
    
    func fetchMeals(withReference ref: DatabaseReference) {
        ref.child("dhall").observeSingleEvent(of: .value) { (snapshot) in
            self.lunchFoods = [Food]()
            self.dinnerFoods = [Food]()
            if let dhallDict = snapshot.value as? NSDictionary {
                let allFoods = dhallDict.value(forKey: "foods") as! NSDictionary
                let meals = dhallDict.value(forKey: "meals") as! NSDictionary
                if let selectedDate = self.date {
                    guard let selectedMeal = meals.value(forKey: String(selectedDate.description.split(separator: " ")[0])) as? NSDictionary else {
                        let ac = UIAlertController(title: "Error", message: "No menu found for date \(selectedDate.description.split(separator: " ")[0])", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self.present(ac, animated: true)
                        return
                    }
                    for case let (meal as String, foods as [String]) in selectedMeal {
                        for food in foods {
                            let foodItem = allFoods.value(forKey: food) as! NSDictionary
                            if meal == "Lunch" {
                                self.lunchFoods.append(Food(name: foodItem.value(forKey: "name") as! String, station: foodItem.value(forKey: "station") as! String, description: foodItem.value(forKey: "description") as! String))
                            } else {
                                self.dinnerFoods.append(Food(name: foodItem.value(forKey: "name") as! String, station: foodItem.value(forKey: "station") as! String, description: foodItem.value(forKey: "description") as! String))
                            }
                        }
                    }
                    self.dataToDisplay = self.lunchFoods
                    self.tableView.reloadData()
                } else {
                    return
                }
            }
        }
    }

}
