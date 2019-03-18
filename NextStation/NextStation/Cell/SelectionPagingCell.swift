//
//  SelectionPagingCell.swift
//  NextStation
//
//  Created by Jonathan Martins on 10/02/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import UIKit
import Parchment

class SelectionPagingCell: PagingCell {
    
    private var options: PagingOptions?
    
    // The line's name
    private let roundedCorner: RoundedCornerLabel = {
        let roundedCorner = RoundedCornerLabel()
        roundedCorner.label.numberOfLines = 1
        roundedCorner.label.textAlignment = .center
        roundedCorner.border_Color = .clear
        roundedCorner.corner_Radius = 12
        roundedCorner.label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        roundedCorner.translatesAutoresizingMaskIntoConstraints = false
        return roundedCorner
    }()
    
    /// Adds the constraints to the views in this cell
    private func setupConstraints(){
        self.addSubview(roundedCorner)
        NSLayoutConstraint.activate([
            roundedCorner.centerYAnchor .constraint(equalTo: self.centerYAnchor),
            roundedCorner.leadingAnchor .constraint(equalTo: self.leadingAnchor , constant: 5),
            roundedCorner.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupConstraints()
    }
    
    override func setPagingItem(_ pagingItem: PagingItem, selected: Bool, options: PagingOptions) {
        self.options = options
        
        let item = (pagingItem as! SelectionItem)
        
        // Sets the text of the item
        if let line = item.line{
            roundedCorner.label.text = "Linha \(line.number.rawValue)"
        }
        else{
            roundedCorner.label.text = "Status"
        }
        
        /// Changes the color of the view if it is checked
        if selected{
            let colour = item.line?.colour ?? "#0C3D6D"
            roundedCorner.label.textColor = .white
            roundedCorner.backgroundColor = UIColor.init(hexString: colour)
        }
        else{
            roundedCorner.backgroundColor = .clear
            roundedCorner.label.textColor = .lightGray
        }
    }
}

struct SelectionItem: PagingItem, Hashable, Comparable {
    
    let index:Int
    let line:Line?
    
    init(index:Int, line: Line?) {
        self.index = index
        self.line  = line
    }
    
    var hashValue: Int {
        return index
    }
    
    static func ==(lhs: SelectionItem, rhs: SelectionItem) -> Bool {
        return (lhs.index == rhs.index && lhs.line?.number == rhs.line?.number)
    }
    
    static func <(lhs: SelectionItem, rhs: SelectionItem) -> Bool {
        return lhs.index < rhs.index
    }
}


