//
//  ViewController.swift
//  DhallApp
//
//  Created by Aaron Brill on 8/15/19.
//  Copyright © 2019 Aaron Brill. All rights reserved.
//

import UIKit
import SwiftSoup

class ViewController: UIViewController {

    
    var document: Document = Document.init("")
    
    var menuURLs: [String] = [String]()
    
    @IBAction func lunchTapped(_ sender: UIButton) {

        guard let webVC = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as? WebViewController else {
            return
        }
        
        fetchURLs()
        let url = getFirstURL()
        webVC.url = url
        
        self.navigationController?.pushViewController(webVC, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        } catch let error {
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
                    menuURLs.append(html)
                }
                
                
            }
            
        } catch let error {
            return
        }
    }
    
    func getFirstURL() -> String {
        
        let range = NSRange(location: 0, length: menuURLs[0].utf16.count)
        let regex = try! NSRegularExpression(pattern: "/.*\\.pdf")
        let match = regex.firstMatch(in: menuURLs[0], options: [], range: range)
        let r = match?.range
        let matchString = menuURLs[0] as NSString
        let url = matchString.substring(with: r!)
        return "https://www.skidmore.edu\(url)"
    }


}

