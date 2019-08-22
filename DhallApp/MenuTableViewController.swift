//
//  MenuTableViewController.swift
//  
//
//  Created by Aaron Brill on 8/18/19.
//

import UIKit

class MenuTableViewController: UITableViewController, UISearchResultsUpdating {
    
    
    var foods = [Food]()
    var filteredTableFoods = [Food]()
    var resultSearchController = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            
            tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredTableFoods.removeAll(keepingCapacity: false)
        
        guard let text = searchController.searchBar.text else {return}
        filteredTableFoods = foods.filter { (food: Food) in
            return food.name.prefix(text.count).lowercased() == text.lowercased()
        }
        
        self.tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return Food.Station.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (resultSearchController.isActive) {
            return filteredTableFoods.filter { (food: Food) in
                return food.station?.rawValue == section
            }.count
        }
        let correctStation = foods.filter { (food: Food) in
            return food.station?.rawValue == section      }
        return correctStation.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Food", for: indexPath)
        
        if(resultSearchController.isActive) {
            let correctStation = filteredTableFoods.filter { (food: Food) in
                return food.station?.rawValue == indexPath.section
            }
            cell.textLabel?.text = correctStation[indexPath.row].name
            return cell
        }
        
        let correctStation = foods.filter { (food: Food) in
            return food.station?.rawValue == indexPath.section
        }
        
        cell.textLabel?.text = correctStation[indexPath.row].name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var item: Food
        if(resultSearchController.isActive) {
            let correctStation = filteredTableFoods.filter { (food: Food) in
                return food.station?.rawValue == indexPath.section
            }
            item = correctStation[indexPath.row]
        } else {
            let correctStation = foods.filter { (food: Food) in
                return food.station?.rawValue == indexPath.section
            }
            item = correctStation[indexPath.row]
        }
        
        let ac = UIAlertController(title: item.name, message: item.description, preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        present(ac, animated: true)
        
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
