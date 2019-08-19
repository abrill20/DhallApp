//
//  TableTableViewController.swift
//  DhallApp
//
//  Created by Aaron Brill on 8/15/19.
//  Copyright © 2019 Aaron Brill. All rights reserved.
//

import UIKit
import SwiftSoup

class TableViewController: UITableViewController {

    var document: Document = Document.init("")
    
    var urls: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchURLs()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urls.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Menu", for: indexPath)
        let urlString = parseString(str: urls[indexPath.row])
        
        
        
        
        cell.textLabel?.text = urlString
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "WebViewController") as? WebViewController {
            vc.url = getURL(row: indexPath.row)
            vc.menuTitle = tableView.cellForRow(at: indexPath)?.textLabel?.text ?? "Menu"
            
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    
    func fetchURLs() {
        
        guard let url = URL(string: "https://www.skidmore.edu/diningservice/menus/index.php" ) else {
            // an error occurred TODO: show alert
            return
        }
        
        do {
            // content of url
            let html = try String.init(contentsOf: url)
            // parse it into a Document
            document = try SwiftSoup.parse(html)
            // parse css query
            parse()
        } catch let _ {
            // an error occurred
            return
        }
        return
    }
    
    
    func parse() {
        do {
            // firn css selector
            let elements: Elements = try document.select("a")
            //transform it into a local object (Item)
            for element in elements {
                let text = try element.text()
                if (text == "Lunch" || text == "Dinner") {
                    let html = try element.outerHtml()
                    urls.append(html)
                }
                
                
            }
            
        } catch let _ {
            return
        }
    }
    
    func getURL(row: Int) -> String {
        
        let range = NSRange(location: 0, length: urls[row].utf16.count)
        let regex = try! NSRegularExpression(pattern: "/.*\\.pdf")
        let match = regex.firstMatch(in: urls[row], options: [], range: range)
        let r = match?.range
        let matchString = urls[row] as NSString
        let url = matchString.substring(with: r!)
        return "https://www.skidmore.edu\(url)"
    }
    
    func parseString(str: String) -> String {
        
        let range = NSRange(location: 0, length: str.utf16.count)
        let regex = try! NSRegularExpression(pattern: "[^/]*\\.pdf")
        let match = regex.firstMatch(in: str, options: [], range: range)
        let r = match?.range
        let matchString = str as NSString
        let res = matchString.substring(with: r!)
        return res
    }
    
}

