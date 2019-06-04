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
    private let alertWindow = AlertWindow()
    
    static let shared = AlertPresenter()
    
    // MARK: - Init
    
    init() {
        self.alertWindow.delegate = self
    }
    
    // MARK: - Alerts
    
    func presentAlertViewModel(_ alertViewModel: AlertViewModel) {
        alertQueue.enqueue(alertViewModel)
        
        if !alertWindow.isKeyWindow {
            showNextAlertIfPresent()
        }
    }
    
    // MARK: - AlertWindowDelegate
    
    func alertDismissed() {
        showNextAlertIfPresent()
    }
    
    private func showNextAlertIfPresent() {
        guard let alertViewModel = alertQueue.dequeue() else {
            return
        }
        
        alertWindow.makeKeyAndVisible()
        alertWindow.presentAlertViewModel(alertViewModel)
    }
}
