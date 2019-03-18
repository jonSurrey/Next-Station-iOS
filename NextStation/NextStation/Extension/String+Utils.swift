//
//  String+Utils.swift
//  NextStation
//
//  Created by Jonathan Martins on 21/02/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import UIKit
import Foundation

extension String{
    
    /// Returns the String lowercased and with no accecents
    func normalized()->String{
        return self.lowercased().folding(options: .diacriticInsensitive, locale: nil)
    }
}

extension NSMutableAttributedString {
    
    /// Creates a bold AttributedString to a from a given text
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        return self
    }
    
    /// Creates a normal AttributedString to a from a given text
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let normal = NSAttributedString(string: text)
        append(normal)
        return self
    }
}
