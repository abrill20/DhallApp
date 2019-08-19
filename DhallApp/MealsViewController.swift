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

        var foods = [Food]()
        
        let ref = Database.database().reference()
        
        ref.child("testLunch").observeSingleEvent(of: .value) { (snapshot) in
            if let mealDict = snapshot.value as? NSDictionary {
                for key in mealDict.allKeys {
                    let food = mealDict.value(forKey: key as! String) as! NSDictionary
                    let stationName = food.value(forKey: "station") as! String
                    var station = Food.Station.emilysGarden
                    switch stationName {
                    case "emily": station = Food.Station.emilysGarden
                    case "diner": station = Food.Station.diner
                    default: break
                    }
                    let foodName = food.value(forKey: "name") as! String
                    
                    foods.append(Food(name: foodName, station: station))
                }
                self.meals.append(Meal(name: "Test Lunch", foods: foods))
                self.tableView.reloadData()
            }
        }
        
        
    }

    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Meal", for: indexPath)
        let meal = meals[indexPath.row]
        cell.textLabel?.text = meal.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController {
            // TODO: Make Menu View conttroller
            
            vc.foods = meals[indexPath.row].foods

            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    

}
