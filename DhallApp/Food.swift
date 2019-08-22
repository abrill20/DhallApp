//
//  Food.swift
//  DhallApp
//
//  Created by Aaron Brill on 8/17/19.
//  Copyright © 2019 Aaron Brill. All rights reserved.
//

import Foundation

struct Food {
    var name: String
    var station: Station?
    var description: String
    enum Station: Int, CaseIterable {
        case emilysGarden
        case diner
        case global
    }
    
    init(name: String, station: Station, description: String) {
        self.name = name
        self.station = station
        self.description = description
    }
    
    init(name: String, station: String, description: String) {
        self.name = name
        switch station.lowercased() {
        case "emily", "emily's garden": self.station = .emilysGarden
        case "diner": self.station = .diner
        case "global": self.station = .global
        default: self.station = nil
        }
        self.description = description
    }
}
