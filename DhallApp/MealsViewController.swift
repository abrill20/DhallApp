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
            // TODO: Make Menu View conttroller
            
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
                
                for case let (date as String, value as NSDictionary) in meals {
                    for case let (meal, foods as [String]) in value {
                        var mealFoods = [Food]()
                        for food in foods {
                            let foodItem = allFoods.value(forKey: food) as! NSDictionary
                            print(foodItem)
                            mealFoods.append(Food(name: foodItem.value(forKey: "name") as! String, station: foodItem.value(forKey: "station") as! String, description: foodItem.value(forKey: "description") as! String))
                        }
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd"
                        self.meals.append(Meal(name: meal as! String, foods: mealFoods, date: formatter.date(from: date) ?? Date()))
                    }
                }
                
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }
    }
}
