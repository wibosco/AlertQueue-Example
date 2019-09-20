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
    private var alertQueue = Queue<UIViewController>()
    private var alertWindow: AlertWindow?
    
    static let shared = AlertPresenter()
    
    // MARK: - Present
    
    func presentAlert<T>(withAlertViewModel alertViewModel: T) {
        let viewController = self.alertViewController(from: alertViewModel)
        alertQueue.enqueue(viewController)
        
        showNextAlertIfPresent()
    }
    
    private func showNextAlertIfPresent() {
        guard alertWindow == nil else {
            return
        }
        
        guard let viewController = alertQueue.dequeue() else {
            return
        }

        let alertWindow = AlertWindow(withViewController: viewController)
        alertWindow.delegate = self
        
        alertWindow.present()
        
        self.alertWindow = alertWindow
    }
    
    // MARK: - AlertWindowDelegate
    
    func alertWindow(_ alertWindow: AlertWindow, didDismissAlert viewController: UIViewController) {
        self.alertWindow = nil
        showNextAlertIfPresent()
    }
    
    // MARK: - WindowPresentationViewModel
    
    private func alertViewController<T>(from alertViewModel: T) -> UIViewController {
        let viewController: UIViewController
        if let alertViewModel = alertViewModel as? StandardAlertViewModel {
            viewController = createStandardAlertController(from: alertViewModel)
        } else if let alertViewModel = alertViewModel as? InformationAlertViewModel {
            viewController = createInformationalAlertViewController(from: alertViewModel)
        } else if let alertViewModel = alertViewModel as? ErrorAlertViewModel {
            viewController = createErrorAlertViewController(from: alertViewModel)
        } else {
            fatalError("Unknown Alert type: \(alertViewModel.self)")
        }
        
        return viewController
    }
    
    // MARK: - ViewControllers
    
    private func createStandardAlertController(from alertViewModel: StandardAlertViewModel) -> UIAlertController {
        let alertController = UIAlertController(title: alertViewModel.title, message: alertViewModel.message, preferredStyle: .alert)
        
        for button in alertViewModel.buttons {
            let action = UIAlertAction(title: button.title, style: button.style.actionStyle) { _ in
                button.action?()
            }
            
            alertController.addAction(action)
        }
        
        return alertController
    }
    
    private func createInformationalAlertViewController(from alertViewModel: InformationAlertViewModel) -> InformationalAlertViewController {
        let storyboard = UIStoryboard(name: "Alerts", bundle: nil)
        guard let alertController = storyboard.instantiateViewController(withIdentifier: "InformationalAlertViewController") as? InformationalAlertViewController else {
            fatalError("Custom alert type does not exist")
        }
        let _ = alertController.view
        
        let dismissingButton = InformationalAlertButton(title: alertViewModel.button.title) {
            self.alertWindow?.dismiss()
        }
        let dismissingAlertViewModel = InformationAlertViewModel(title: alertViewModel.title, button: dismissingButton)
        
        alertController.configure(withViewModel: dismissingAlertViewModel)
        
        return alertController
    }
    
    private func createErrorAlertViewController(from alertViewModel: ErrorAlertViewModel) -> ErrorAlertViewController {
        let storyboard = UIStoryboard(name: "Alerts", bundle: nil)
        guard let alertController = storyboard.instantiateViewController(withIdentifier: "ErrorAlertViewController") as? ErrorAlertViewController else {
            fatalError("Custom alert type does not exist")
        }
        let _ = alertController.view
        
        let dismissingButton = ErrorAlertButton(title: alertViewModel.button.title) {
            self.alertWindow?.dismiss()
        }
        let dismissingAlertViewModel = ErrorAlertViewModel(title: alertViewModel.title, message: alertViewModel.message, icon: alertViewModel.icon, button: dismissingButton)
        
        alertController.configure(withViewModel: dismissingAlertViewModel)
        
        return alertController
    }
}

fileprivate extension StandardAlertButtonStyle {
    var actionStyle: UIAlertAction.Style {
        switch self {
        case .default:
            return .default
        case .cancel:
            return .cancel
        case .destructive:
            return .destructive
        }
    }
}
