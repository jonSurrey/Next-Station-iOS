//
//  UICollectionView+Utils.swift
//  NextStation
//
//  Created by Jonathan Martins on 04/02/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import UIKit
import Foundation

extension UICollectionView{
    
    /// Returns a UICollectionViewCell for a given Class Type
    func getCell<T:UICollectionViewCell>(_ indexPath: IndexPath, _ type:T.Type) -> T?{
        return self.dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as? T
    }
    
    /// Register a Cell in the CollectionView, given an UICollectionViewCell Type
    func registerCell<T:UICollectionViewCell>(_ cell:T.Type){
        self.register(T.self, forCellWithReuseIdentifier: String(describing: T.self))
    }
}
