//
//  InformationalAlertViewController.swift
//  AlertQueue-Example
//
//  Created by William Boles on 03/06/2019.
//  Copyright © 2019 William Boles. All rights reserved.
//

import UIKit

class InformationalAlertViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    private var viewModel: InformationAlertViewModel?
    
    // MARK: - Configure
    
    func configure(withViewModel viewModel: InformationAlertViewModel) {
        self.viewModel = viewModel
        
        titleLabel.text = viewModel.title
        button.setTitle(viewModel.button.title, for: .normal)
    }
    
    // MARK: - Actions
    
    @IBAction func buttonPressed(_ sender: Any) {
        guard let viewModel = viewModel else {
            fatalError("Alert needs a view model")
        }
        
        viewModel.button.action?()
    }
}
