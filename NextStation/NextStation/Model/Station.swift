//
//  Station.swift
//  NextStation
//
//  Created by Jonathan Martins on 24/01/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import Foundation

struct Station:Filterable {
    
    var filterValue: String {
        return name
    }
    
    let id:Int
    let order:Int
    let lineId:Int
    let name:String
    let address:String
    let latitude:Double
    let longitude:Double
    let tranferences:[Station]
    
    init(_ id:Int, _ lineId:Int, _ order:Int, _ name:String, _ address:String, _ latitude:Double, _ longitude:Double, _ tranferences:[Station]) {
        self.id           = id
        self.name         = name
        self.order        = order
        self.lineId       = lineId
        self.address      = address
        self.latitude     = latitude
        self.longitude    = longitude
        self.tranferences = tranferences
    }
    
    init() {
        self.id           = -1
        self.name         = ""
        self.order        = 0
        self.lineId       = -1
        self.address      = ""
        self.latitude     = 0
        self.longitude    = 0
        self.tranferences = []
    }
}
