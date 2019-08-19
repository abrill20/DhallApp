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
    
    init(name: String, foods: [Food]) {
        self.name = name
        self.foods = foods
    }
    
}
