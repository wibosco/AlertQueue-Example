//
//  AlertWindow.swift
//  AlertQueue-Example
//
//  Created by William Boles on 26/05/2019.
//  Copyright © 2019 William Boles. All rights reserved.
//

import Foundation
import UIKit

protocol MonitoringNavigationChangesDelegate {
    func didDismissPresentedViewController(_ monitoringNavigationController: MonitoringNavigationController)
}

class MonitoringNavigationController: UINavigationController {
    var navigationChangesDelegate: MonitoringNavigationChangesDelegate?
    
    private var didPresentViewController: Bool = false
    
    // MARK: - ViewLifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        informDelegateIfNeeded()
    }
    
    // MARK: - Presentation
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        super.present(viewControllerToPresent, animated: flag) {
            self.didPresentViewController = true
        } 
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag) {
            completion?()
            
            self.informDelegateIfNeeded()
        }
    }
    
    // MARK: - Delegate
    
    private func informDelegateIfNeeded() {
        if didPresentViewController {
            navigationChangesDelegate?.didDismissPresentedViewController(self)
            
            didPresentViewController = false
        }
    }
}

protocol AlertWindowDelegate {
    func alertDismissed()
}

class AlertWindow: UIWindow, MonitoringNavigationChangesDelegate {
    
    var delegate: AlertWindowDelegate?
    
    // MARK: - Init
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        
        let navigationController = MonitoringNavigationController(rootViewController: UIViewController())
        navigationController.navigationChangesDelegate = self
        rootViewController = navigationController
        
        windowLevel = .alert
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("Unavailable")
    }
    
    // MARK: - MonitoringNavigationChangesDelegate
    
    func didDismissPresentedViewController(_ monitoringNavigationController: MonitoringNavigationController) {
        resignKeyAndHide()
        
        delegate?.alertDismissed()
    }
    
    // MARK: - Present
    
    func presentAlertViewModel(_ alertViewModel: AlertViewModel) {
        rootViewController?.present(alertViewModel.viewController, animated: alertViewModel.animated, completion: alertViewModel.completion)
    }
    
    // MARK: - Resign
    
    func resignKeyAndHideIfNeeded() {
        if rootViewController?.presentedViewController == nil {
            resignKeyAndHide()
        }
    }
    
    private func resignKeyAndHide() {
        resignKey()
        isHidden = true
    }
}
