//
//  StationItem.swift
//  NextStation
//
//  Created by Jonathan Martins on 28/02/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import Foundation

class StationItem {
    
    /// Indicates this item is selected or not
    var isSelected:Bool = false
    
    /// The colour of the line in which the station of this item belongs
    var lineColour:String
    
    /// The station being manioulated
    let station:Station
    
    /// The transferences that the station has
    var tranferences:[Station] {
        get{
            return station.tranferences
        }
    }
    
    init(colour:String, _ station:Station, isSelected:Bool=false) {
        self.station    = station
        self.lineColour = colour
        self.isSelected = isSelected
    }
}
