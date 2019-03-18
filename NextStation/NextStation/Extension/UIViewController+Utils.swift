//
//  UIViewController+Utils.swift
//  NextStation
//
//  Created by Jonathan Martins on 19/02/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import UIKit
import Foundation

extension UIViewController{
    
    /// Sets the colour of the navigationBar to be transparent
    func setNavigationBar(to colour:UIColor){
        self.navigationController?.navigationBar.isTranslucent   = false
        self.navigationController?.navigationBar.barTintColor    = colour
        self.navigationController?.navigationBar.backgroundColor = colour
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    /// Sets a close button to the navigationBar
    func addCloseButtonToNavigationBar(){
        let closeButton:UIBarButtonItem = {
            let buttonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismissViewController))
            buttonItem.tintColor = .darkGray
            return buttonItem
        }()
        self.navigationItem.leftBarButtonItem = closeButton
    }
    
    /// Dismiss the ViewController
    @objc func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
}
