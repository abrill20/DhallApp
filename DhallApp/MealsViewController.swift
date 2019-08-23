//
//  MenuViewController.swift
//  DhallApp
//
//  Created by Aaron Brill on 8/18/19.
//  Copyright © 2019 Aaron Brill. All rights reserved.
//

import UIKit
import FirebaseDatabase

class MealsViewController: UITableViewController {
    
    var meals = [Meal]()
    var date: Date?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshMealsData(_:)), for: .valueChanged)
        
        fetchMeals(withReference: Database.database().reference())
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Meal", for: indexPath)
        let meal = meals[indexPath.row]
        let dateArr = meal.date.description.split(separator: " ")
        cell.textLabel?.text = "\(meal.name) \(dateArr[0])"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController {
            vc.foods = meals[indexPath.row].foods

            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @objc func refreshMealsData(_ sender: Any) {
        fetchMeals(withReference: Database.database().reference())
    }
    
    func fetchMeals(withReference ref: DatabaseReference) {
        ref.child("dhall").observeSingleEvent(of: .value) { (snapshot) in
            self.meals = [Meal]()
            if let dhallDict = snapshot.value as? NSDictionary {
                let allFoods = dhallDict.value(forKey: "foods") as! NSDictionary
                let meals = dhallDict.value(forKey: "meals") as! NSDictionary
                if let selectedDate = self.date {
                    guard let selectedMeal = meals.value(forKey: String(selectedDate.description.split(separator: " ")[0])) as? NSDictionary else {
                        let ac = UIAlertController(title: "Error", message: "No menu found for date \(String(describing: self.date?.description))", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self.present(ac, animated: true)
                        return
                    }
                    for case let (meal, foods as [String]) in selectedMeal {
                        var mealFoods = [Food]()
                        for food in foods {
                            let foodItem = allFoods.value(forKey: food) as! NSDictionary
                            mealFoods.append(Food(name: foodItem.value(forKey: "name") as! String, station: foodItem.value(forKey: "station") as! String, description: foodItem.value(forKey: "description") as! String))
                        }
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd"
                        self.meals.append(Meal(name: meal as! String, foods: mealFoods, date: selectedDate))
                    }
                } else {
                    for case let (date as String, value as NSDictionary) in meals {
                        for case let (meal, foods as [String]) in value {
                            var mealFoods = [Food]()
                            for food in foods {
                                let foodItem = allFoods.value(forKey: food) as! NSDictionary
                                mealFoods.append(Food(name: foodItem.value(forKey: "name") as! String, station: foodItem.value(forKey: "station") as! String, description: foodItem.value(forKey: "description") as! String))
                            }
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd"
                            self.meals.append(Meal(name: meal as! String, foods: mealFoods, date: formatter.date(from: date) ?? Date()))
                        }
                    }
                }
                
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }
    }
}
