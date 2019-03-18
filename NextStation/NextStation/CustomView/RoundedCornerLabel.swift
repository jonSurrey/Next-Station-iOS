//
//  RoundedCornerLabel.swift
//  NextStation
//
//  Created by Jonathan Martins on 03/02/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import UIKit
import Foundation

class RoundedCornerLabel:UIView{
    
    let label:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 2
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.border_Width  = 1
        self.corner_Radius = 11
        
        addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor     .constraint(equalTo: self.topAnchor     , constant:  5),
            label.bottomAnchor  .constraint(equalTo: self.bottomAnchor  , constant: -5),
            label.leadingAnchor .constraint(equalTo: self.leadingAnchor , constant:  10),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

