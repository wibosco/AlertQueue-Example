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
    func alertWindow(_ alertWindow: AlertWindow, didDismissAlert alertController: UIAlertController)
}

class AlertWindow: UIWindow, HoldingDelegate {
    weak var delegate: AlertWindowDelegate?
    
    private let holdingViewController: HoldingViewController
    
    // MARK: - Init
    
    init(withAlertController alertController: UIAlertController) {
        holdingViewController = HoldingViewController(withAlertController: alertController)
        
        super.init(frame: UIScreen.main.bounds)
        
        rootViewController = holdingViewController
        
        holdingViewController.delegate = self
    
        windowLevel = .normal
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("Unavailable")
    }
    
    // MARK: - HoldingDelegate
    
    fileprivate func viewController(_ viewController: HoldingViewController, didDismissAlert alertController: UIAlertController) {
        resignKeyAndHide()
        delegate?.alertWindow(self, didDismissAlert: alertController)
    }
    
    // MARK: - Present
    
    func present() {
        makeKeyAndVisible()
    }

    // MARK: - Resign
    
    private func resignKeyAndHide() {
        resignKey()
        isHidden = true
    }
}

fileprivate protocol HoldingDelegate: class {
    func viewController(_ viewController: HoldingViewController, didDismissAlert alertController: UIAlertController)
}

fileprivate class HoldingViewController: UIViewController {
    private let alertController: UIAlertController
    
    weak var delegate: HoldingDelegate?
    
    // MARK: - Init
    
    init(withAlertController alertController: UIAlertController) {
        self.alertController = alertController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewLifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        present(alertController, animated: true, completion: nil)
    }

    // MARK: - Dismiss
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        //Called when a UIAlertController instance is dismissed
        super.dismiss(animated: flag) {
            completion?()

            self.delegate?.viewController(self, didDismissAlert: self.alertController)
        }
    }
}
