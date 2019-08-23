//
//  ViewController.swift
//  DhallApp
//
//  Created by Aaron Brill on 8/22/19.
//  Copyright © 2019 Aaron Brill. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var datePicker: UIDatePicker!
    
    @IBAction func calendarButtonTapped(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "LD") as? LunchDinnerViewController {
            
            vc.date = datePicker.date - (60*60*4)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

