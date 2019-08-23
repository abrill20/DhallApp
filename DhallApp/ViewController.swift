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
        if let vc = storyboard?.instantiateViewController(withIdentifier: "MealsViewController") as? MealsViewController {
            
            vc.date = datePicker.date - (60*60*4)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()


        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension Date {
    var localizedDescription: String {
        return description(with: .current)
    }
}
