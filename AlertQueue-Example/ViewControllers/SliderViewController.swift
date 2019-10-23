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
    @IBOutlet weak var showButton: UIButton!

    // MARK: - ViewLifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateButtonTitleToMatchSlider(alertsToBeShownSlider)
    }
    
    // MARK: - Slider
    
    @IBAction func alertsToBeShownSliderChanged(_ slider: UISlider) {
        snapSliderToNearestValue(slider)
        updateButtonTitleToMatchSlider(slider)
    }
    
    private func snapSliderToNearestValue(_ slider: UISlider) {
        slider.setValue(slider.nearestWholeValue, animated: true)
    }
    
    private func updateButtonTitleToMatchSlider(_ slider: UISlider) {
        let sliderValue = Int(alertsToBeShownSlider.nearestWholeValue)
        let message: String
        if sliderValue > 1 {
            message = "Show \(sliderValue) alerts"
        } else {
            message = "Show 1 alert"
        }
        showButton.setTitle(message, for: .normal)
    }
    
    // MARK: - Button
    
    @IBAction func showButtonPressed(_ sender: Any) {
        let alertsToBeShown = Int(alertsToBeShownSlider.nearestWholeValue)
        
        for index in 0..<alertsToBeShown {
            let alertController = createAlertController(forIndex: index)
            
            AlertPresenter.shared.enqueueAlertForPresentation(alertController)
        }
    }
    
    // MARK: - Alerts
    
    private func createAlertController(forIndex index: Int) -> UIAlertController {
        let alertController = UIAlertController(title: "\(index)", message: "This alert has been queued", preferredStyle: .alert)
    
        let dismissAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(dismissAction)
    
        return alertController
    }
}

fileprivate extension UISlider {
    var nearestWholeValue: Float {
        return roundf(value)
    }
}
