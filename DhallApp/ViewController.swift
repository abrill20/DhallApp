//
//  ViewController.swift
//  DhallApp
//
//  Created by Aaron Brill on 8/15/19.
//  Copyright © 2019 Aaron Brill. All rights reserved.
//

import UIKit
import MapKit
import SwiftSoup

class ViewController: UIViewController, MKMapViewDelegate {

    
    @IBAction func lunchTapped(_ sender: UIButton) {
        
        guard let webVC = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as? WebViewController else {
            return
        }
        
        webVC.url = "https://www.skidmore.edu/diningservice/menus/SummerCycle1Lunch2019.pdf"
        
        self.navigationController?.pushViewController(webVC, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

