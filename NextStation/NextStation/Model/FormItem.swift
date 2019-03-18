//
//  FormItem.swift
//  NextStation
//
//  Created by Jonathan Martins on 28/02/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import Foundation

/// Defines the fields that the SMSViewController's form can have
struct FormItem {
    
    /// The types of fields
    enum `Type` {
        case TEXTFIELD_NUMBER
        case TEXTFIELD_TEXT
        case SELECTION_LINE
        case SELECTION_STATION
    }
    
    var data:String? = nil{
        didSet{
            isChecked = data != nil ? true:false
        }
    }
    
    let type:Type
    var label:String
    var items:[BaseModel]
    var isChecked:Bool
    
    init(type:Type, label:String, items:[BaseModel]=[], isChecked:Bool=false) {
        self.type      = type
        self.label     = label
        self.items     = items
        self.isChecked = isChecked
    }
}
