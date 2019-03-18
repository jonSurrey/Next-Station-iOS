//
//  RoundedTextField.swift
//  NextStation
//
//  Created by Jonathan Martins on 19/02/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import UIKit
import Foundation

class RoundedTextField:UIView{
    
    let textField:UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.clearButtonMode = .whileEditing
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.corner_Radius   = 14
        self.backgroundColor = UIColor.init(hexString: "#EEEEEE")
        
        addSubview(textField)
        NSLayoutConstraint.activate([
            textField.topAnchor     .constraint(equalTo: self.topAnchor, constant: 5),
            textField.bottomAnchor  .constraint(equalTo: self.bottomAnchor, constant: -5),
            textField.leadingAnchor .constraint(equalTo: self.leadingAnchor, constant: 15),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
