//
//  Meal.swift
//  DhallApp
//
//  Created by Aaron Brill on 8/17/19.
//  Copyright © 2019 Aaron Brill. All rights reserved.
//

import Foundation

struct Meal {
    var name: String
    var foods: [Food]
    var date: Date
    
    init(name: String, foods: [Food], date: Date) {
        self.name = name
        self.foods = foods
        self.date = date
    }
    
}
