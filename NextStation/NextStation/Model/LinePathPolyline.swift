//
//  LinePathPolyline.swift
//  NextStation
//
//  Created by Jonathan Martins on 03/02/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import MapKit
import Foundation

enum PolylineType {
    case LINE
    case STROKE
}

class LinePathPolyline:MKPolyline{
    var type:PolylineType = .LINE
    var colour:UIColor?
    var number:LineNumber?
}

