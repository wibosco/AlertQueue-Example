//
//  AlertPresenter.swift
//  AlertQueue-Example
//
//  Created by William Boles on 26/05/2019.
//  Copyright © 2019 William Boles. All rights reserved.
//

import Foundation
import UIKit

class AlertPresenter: AlertWindowDelegate {
    private var alertQueue = Queue<UIAlertController>()
    private var alertWindow: AlertWindow?
    
    static let shared = AlertPresenter()
    
    // MARK: - Present
    
    func presentAlert(withAlertController alertController: UIAlertController) {
        alertQueue.enqueue(alertController)
        
        showNextAlertIfPresent()
    }
    
    private func showNextAlertIfPresent() {
        guard alertWindow == nil else {
            return
        }
        
        guard let alertController = alertQueue.dequeue() else {
            return
        }

        let alertWindow = AlertWindow(withAlertController: alertController)
        alertWindow.delegate = self
        
        alertWindow.present()
        
        self.alertWindow = alertWindow
    }
    
    // MARK: - AlertWindowDelegate
    
    func alertWindow(_ alertWindow: AlertWindow, didDismissAlert alertController: UIAlertController) {
        self.alertWindow = nil
        showNextAlertIfPresent()
    }
}
