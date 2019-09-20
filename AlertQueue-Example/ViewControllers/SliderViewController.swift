//
//  ViewController.swift
//  AlertQueue-Example
//
//  Created by William Boles on 28/04/2019.
//  Copyright © 2019 William Boles. All rights reserved.
//

import UIKit

enum AlertType {
    case standard
    case error
    case informational
}

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
        
        var type = AlertType.standard
        for _ in 0...alertsToBeShown {
            switch type {
            case .standard:
                let alertViewModel = createStandardAlertPresentationViewModel()
                AlertPresenter.shared.presentAlert(withAlertViewModel: alertViewModel)
                type = .error
            case .error:
                let alertViewModel = createErrorAlertViewModel()
                AlertPresenter.shared.presentAlert(withAlertViewModel: alertViewModel)
                type = .informational
            case .informational:
                let alertViewModel = createInformationalAlertViewModel()
                AlertPresenter.shared.presentAlert(withAlertViewModel: alertViewModel)
                type = .standard
            }
        }
    }
    
    // MARK: - Alerts
    
    private func createStandardAlertPresentationViewModel() -> StandardAlertViewModel {
        let dismissButton = StandardAlertButton(title: "Dismiss", style: .default, action: nil)
        let alertViewModel = StandardAlertViewModel(title: "Standard alert title", message: "Message for standard alert", buttons: [dismissButton])
        
        return alertViewModel
    }
    
    private func createInformationalAlertViewModel() -> InformationAlertViewModel  {
        let dismissButton = InformationalAlertButton(title: "Dismiss", action: nil)
        let alertViewModel = InformationAlertViewModel(title: "Informational alert title", button: dismissButton)
        
        return alertViewModel
    }
    
    private func createErrorAlertViewModel() -> ErrorAlertViewModel  {
        let icon = UIImage(imageLiteralResourceName: "error-circle")
        let okButton = ErrorAlertButton(title: "OK", action: nil)
        let alertViewModel = ErrorAlertViewModel(title: "Error alert title", message: "Message for error", icon: icon, button: okButton)
        
        return alertViewModel
    }
}
