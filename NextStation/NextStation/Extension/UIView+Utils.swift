//
//  UIView+Utils.swift
//  NextStation
//
//  Created by Jonathan Martins on 07/01/19.
//  Copyright © 2019 Surrey. All rights reserved.
//
import UIKit

extension UIView {
    
    /// Sets how rounded the view should be
    var corner_Radius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    /// Sets the width of the border
    var border_Width: CGFloat{
        get {
            return layer.borderWidth
        }
        set{
            layer.borderWidth = newValue
        }
    }
    
    /// Sets the colour of the border
    var border_Color: UIColor?{
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set{
            layer.borderColor = newValue?.cgColor
        }
    }
    
    /// Adds drop shadow to the view
    func addDropShadow(){
        self.layer.shadowColor   = UIColor.black.cgColor
        self.layer.shadowOffset  = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowRadius  = 3
        self.layer.shadowOpacity = 0.4
    }

    /// Makes the view a circle
    func fullCircle(){
        self.layer.cornerRadius = self.bounds.size.width/2
    }
    
    /// Removes all children of the view
    func removeAllSubviews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
}
