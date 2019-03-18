//
//  TripStep.swift
//  NextStation
//
//  Created by Jonathan Martins on 28/02/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import Foundation

/// Defines the steps to get from one station to another in the TripPlannerViewController
struct TripStep {
    
    /// Types the possible steps state
    enum State {
        case BOARDING
        case GOING
        case TRANFERENCE
        case EXIT
    }
    
    let line:Line
    let state:State
    let station:Station
    let direction:Station?
    
    init(station:Station, direction:Station? = nil, state:State) {
        self.line      = Line(station.lineId)
        self.state     = state
        self.station   = station
        self.direction = direction
    }
}
