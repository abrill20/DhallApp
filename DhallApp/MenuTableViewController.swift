//
//  MenuTableViewController.swift
//  
//
//  Created by Aaron Brill on 8/18/19.
//

import UIKit

class MenuTableViewController: UITableViewController {
    
    var foods = [Food]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return Food.Station.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let correctStation = foods.filter { (food: Food) in
            return food.station.rawValue == section      }
        print("Number of sections: \(correctStation.count)" )
        return correctStation.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Food", for: indexPath)
        
        let correctStation = foods.filter { (food: Food) in
            return food.station.rawValue == indexPath.section
        }
        
        cell.textLabel?.text = correctStation[indexPath.row].name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
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

}
