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
    enum Station: Int, CaseIterable {
        case emilysGarden
        case diner
        case global
    }
    
    init(name: String, station: Station) {
        self.name = name
        self.station = station
    }
    
    init(name: String, station: String) {
        self.name = name
        switch station.lowercased() {
        case "emily", "emily's garden": self.station = .emilysGarden
        case "diner": self.station = .diner
        case "global": self.station = .global
        default: self.station = nil
        }
    }
}
