//
//  UIImageView+Utils.swift
//  NextStation
//
//  Created by Jonathan Martins on 30/01/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import UIKit

extension UIImageView {
    
    /// Change sthe colour of the image
    func tintColour(to newColour:UIColor){
        self.image = self.image!.withRenderingMode(.alwaysTemplate)
        self.tintColor = newColour
    }
}
