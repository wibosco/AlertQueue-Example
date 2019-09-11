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
    private var alertQueue = Queue<AlertViewModel>()
    private var alertWindow: AlertWindow?
    
    static let shared = AlertPresenter()
    
    // MARK: - Present
    
    func presentAlert(withAlertViewModel alertViewModel: AlertViewModel) {
        alertQueue.enqueue(alertViewModel)
        
        showNextAlertIfPresent()
    }
    
    private func showNextAlertIfPresent() {
        guard alertWindow == nil else {
            return
        }
        
        guard let alertViewModel = alertQueue.dequeue() else {
            return
        }

        let alertWindow = AlertWindow(withAlertViewModel: alertViewModel)
        alertWindow.delegate = self
        
        alertWindow.present()
        
        self.alertWindow = alertWindow
    }
    
    // MARK: - AlertWindowDelegate
    
    func alertWindow(_ alertWindow: AlertWindow, didDismissAlertViewModel alertViewModel: AlertViewModel) {
        self.alertWindow = nil
        showNextAlertIfPresent()
    }
}
