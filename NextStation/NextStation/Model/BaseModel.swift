//
//  BaseModel.swift
//  NextStation
//
//  Created by Jonathan Martins on 01/03/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

protocol Filterable {
    var filterValue:String{ get }
}

/// Common struct to be used by all struct that need to extend Filterable
struct BaseModel: Filterable {
    
    var filterValue: String {
        return text
    }

    let id:Int
    let text:String
}
