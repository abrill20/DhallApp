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
        
        let ref = Database.database().reference()
        
        fetchMeals(withReference: ref)
        
        
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
    
    func fetchMeals(withReference ref: DatabaseReference) {
        ref.child("meals").observeSingleEvent(of: .value) { (snapshot) in
            
            if let mealDict = snapshot.value as? NSDictionary {
                for case let (_, mealValue as NSDictionary) in mealDict {
                    var foods = [Food]()
                    let mealName = mealValue.value(forKey: "name") as! String
                    let foodsKey = mealValue.value(forKey: "foods") as! NSDictionary
                    for case let (_, foodValue as NSDictionary) in foodsKey {
                        let food = foodValue.value(forKey: "name") as! String
                        let station = foodValue.value(forKey: "station") as! String
                        foods.append(Food(name: food, station: station))
                    }
                    self.meals.append(Meal(name: mealName, foods: foods))
                    
                }
                self.tableView.reloadData()
            }
        }
    }
    
    

}
