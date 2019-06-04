//
//  AlertViewModel.swift
//  AlertQueue-Example
//
//  Created by William Boles on 26/05/2019.
//  Copyright © 2019 William Boles. All rights reserved.
//

import UIKit

struct AlertViewModel {
    let viewController: UIViewController
    let animated: Bool
    let completion: (() -> Void)?
    
    // MARK: - Init
    
    init(viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        self.viewController = viewController
        self.animated = animated
        self.completion = completion
    }
}
