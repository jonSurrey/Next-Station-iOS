//
//  StationNode.swift
//  NextStation
//
//  Created by Jonathan Martins on 28/02/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import Foundation
import GameplayKit

class StationNode:GKGraphNode {
    
    var station:Station!
    var travelCost: [GKGraphNode: Float] = [:]
    
    init(_ station: Station) {
        self.station = station
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
    }
    
    override func cost(to node: GKGraphNode) -> Float {
        return travelCost[node] ?? 0
    }
    
    func addConnection(to node: GKGraphNode, bidirectional: Bool = true, weight: Float) {
        self.addConnections(to: [node], bidirectional: bidirectional)
        travelCost[node] = weight
        guard bidirectional else { return }
        (node as? StationNode)?.travelCost[self] = weight
    }
}
