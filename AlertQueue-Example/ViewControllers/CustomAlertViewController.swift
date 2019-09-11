//
//  CustomAlertViewController.swift
//  AlertQueue-Example
//
//  Created by William Boles on 03/06/2019.
//  Copyright © 2019 William Boles. All rights reserved.
//

import UIKit

class CustomAlertViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Actions
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
