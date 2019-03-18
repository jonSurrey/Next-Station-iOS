//
//  BaseCell.swift
//  NextStation
//
//  Created by Jonathan Martins on 15/01/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import UIKit

class BaseCell:UITableViewCell{
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Hides the separator of the cell
    func hideSeparator(){
        self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
    }
}
