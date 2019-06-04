//
//  ViewController.swift
//  AlertQueue-Example
//
//  Created by William Boles on 28/04/2019.
//  Copyright © 2019 William Boles. All rights reserved.
//

import UIKit

class SliderViewController: UIViewController {
    
    @IBOutlet weak var alertsToBeShownSlider: UISlider!

    // MARK: - Slider
    
    @IBAction func alertsToBeShownSliderChanged(_ slider: UISlider) {
        snapSliderToNearestValue(alertsToBeShownSlider)
    }
    
    private func snapSliderToNearestValue(_ slider: UISlider) {
        let currentValue = slider.value
        let rounded = roundf(currentValue)
        
        slider.setValue(rounded, animated: true)
    }
    
    // MARK: - Button
    
    @IBAction func showButtonPressed(_ sender: Any) {
        let alertsToBeShown = Int(alertsToBeShownSlider.value)
        
        for index in 0..<alertsToBeShown {
            if index % 2 == 0 {
                AlertPresenter.shared.presentAlertViewModel(createStandardAlertView(index: index))
            } else {
                AlertPresenter.shared.presentAlertViewModel(createCustomAlertViewModel(index: index))
            }
        }
    }
    
    // MARK: - Alerts
    
    private func createStandardAlertView(index: Int) -> AlertViewModel {
        let alertController = UIAlertController(title: "Alert", message: "This standard alert was index: \(index)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        let alertViewModel = AlertViewModel(viewController: alertController)
        
        return alertViewModel
    }
    
    private func createCustomAlertViewModel(index: Int) -> AlertViewModel {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let customAlertController = storyboard.instantiateViewController(withIdentifier: "CustomAlertViewController") as? CustomAlertViewController else {
            print("hey")
            fatalError("Custom alert type does not exist")
        }
        let _ = customAlertController.view
        customAlertController.titleLabelA.text = "This custom alert was index: \(index)"
        
        let alertViewModel = AlertViewModel(viewController: customAlertController)
        
        return alertViewModel
    }
}

