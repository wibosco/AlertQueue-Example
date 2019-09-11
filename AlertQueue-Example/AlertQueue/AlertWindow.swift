//
//  AlertWindow.swift
//  AlertQueue-Example
//
//  Created by William Boles on 26/05/2019.
//  Copyright © 2019 William Boles. All rights reserved.
//

import Foundation
import UIKit

protocol AlertWindowDelegate: class {
    func alertWindow(_ alertWindow: AlertWindow, didDismissAlertViewModel alertViewModel: AlertViewModel)
}

class AlertWindow: UIWindow, AlertHoldingDelegate {
    weak var delegate: AlertWindowDelegate?
    
    private let alertViewModel: AlertViewModel
    private var viewController: UIViewController?
    
    // MARK: - Init
    
    init(withAlertViewModel alertViewModel: AlertViewModel) {
        self.alertViewModel = alertViewModel
        
        super.init(frame: UIScreen.main.bounds)
    
        windowLevel = .normal
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("Unavailable")
    }
    
    // MARK: - AlertHoldingDelegate
    
    fileprivate func viewController(_ viewController: AlertHoldingViewController, didDismissAlert alertViewModel: AlertViewModel) {
        resignKeyAndHide()
        delegate?.alertWindow(self, didDismissAlertViewModel: alertViewModel)
    }
    
    // MARK: - Present
    
    func present() {
        makeKeyAndVisible()
        
        let holdingViewController = AlertHoldingViewController(withAlertViewModel: alertViewModel)
        holdingViewController.delegate = self
        rootViewController = holdingViewController
    }

    // MARK: - Resign
    
    private func resignKeyAndHide() {
        resignKey()
        isHidden = true
    }
}

fileprivate protocol AlertHoldingDelegate: class {
    func viewController(_ viewController: AlertHoldingViewController, didDismissAlert alertViewModel: AlertViewModel)
}

fileprivate class AlertHoldingViewController: UIViewController {
    private let alertViewModel: AlertViewModel
    private var presentedAlert: Bool = false
    
    weak var delegate: AlertHoldingDelegate?
    
    // MARK: - Init
    
    init(withAlertViewModel alertViewModel: AlertViewModel) {
        self.alertViewModel = alertViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewLifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if presentedAlert {
            //Called when UIViewController is dismissed
            alertDismissed()
        } else {
            present(alertViewModel.viewController, animated: alertViewModel.animated) {
                self.alertViewModel.completion?()
                self.presentedAlert = true
            }
        }
    }
    
    // MARK: - Presentation
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        //Called when UIAlertController is dismissed
        super.dismiss(animated: flag) {
            completion?()
            
            self.alertDismissed()
        }
    }
    
    // MARK: - Delegate
    
    private func alertDismissed() {
        delegate?.viewController(self, didDismissAlert: alertViewModel)
    }
}
