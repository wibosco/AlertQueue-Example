//
//  UIViewController+Child.swift
//  AlertQueue-Example
//
//  Created by William Boles on 18/09/2019.
//  Copyright © 2019 William Boles. All rights reserved.
//
// Copied from https://www.swiftbysundell.com/basics/child-view-controllers/

import UIKit

extension UIViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        guard parent != nil else {
            return
        }
        
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
