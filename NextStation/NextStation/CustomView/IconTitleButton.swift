//
//  IconTitleButton.swift
//  NextStation
//
//  Created by Jonathan Martins on 30/01/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import UIKit
import Foundation

class IconTitleButton:UIView{
    
    let icon:UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    let label:UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 9, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(icon)
        addSubview(label)
        NSLayoutConstraint.activate([
            icon.widthAnchor .constraint(equalToConstant: 23),
            icon.heightAnchor.constraint(equalToConstant: 23),
            icon.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            icon.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            
            label.centerXAnchor.constraint(equalTo: icon.centerXAnchor),
            label.topAnchor.constraint(equalTo: icon.bottomAnchor,constant:3),
            label.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///
    func setColour(to colour:UIColor){
        icon.tintColour(to: colour)
        label.textColor = colour
    }
}

