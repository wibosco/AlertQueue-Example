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
    func alertWindow(_ alertWindow: AlertWindow, didDismissAlert viewController: UIViewController)
}

class AlertWindow: UIWindow, HoldingDelegate {
    weak var delegate: AlertWindowDelegate?
    
    private let holdingViewController: HoldingViewController
    
    // MARK: - Init
    
    init(withViewController viewController: UIViewController) {
        holdingViewController = HoldingViewController(withAlertViewController: viewController)
        
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
    
    fileprivate func viewController(_ viewController: HoldingViewController, didDismissAlert alertViewController: UIViewController) {
        resignKeyAndHide()
        delegate?.alertWindow(self, didDismissAlert: alertViewController)
    }
    
    // MARK: - Present
    
    func present() {
        makeKeyAndVisible()
    }
    
    func dismiss() {
        holdingViewController.dismissAlert()
    }

    // MARK: - Resign
    
    private func resignKeyAndHide() {
        resignKey()
        isHidden = true
    }
}

fileprivate protocol HoldingDelegate: class {
    func viewController(_ viewController: HoldingViewController, didDismissAlert alertViewController: UIViewController)
}

fileprivate class HoldingViewController: UIViewController, UIViewControllerTransitioningDelegate {
    private let alertViewController: UIViewController
    private var containerViewController: CustomAlertContainerViewController?
    
    weak var delegate: HoldingDelegate?
    
    // MARK: - Init
    
    init(withAlertViewController alertViewController: UIViewController) {
        self.alertViewController = alertViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewLifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let alertViewController = alertViewController as? UIAlertController {
            presentStandardAlertController(alertViewController)
        } else {
            presentCustomAlertController(alertViewController)
        }
    }
    
    // MARK: - Present
    
    private func presentStandardAlertController(_ standardAlertController: UIAlertController) {
        present(alertViewController, animated: true, completion: nil)
    }
    
    private func presentCustomAlertController(_ customAlertController: UIViewController) {
        let containerViewController = CustomAlertContainerViewController(withChildViewController: alertViewController)
        containerViewController.modalPresentationStyle = .overCurrentContext
        containerViewController.modalTransitionStyle = .crossDissolve
        containerViewController.transitioningDelegate = self
        present(containerViewController, animated: true, completion: nil)

        self.containerViewController = containerViewController
    }

    // MARK: - Dismiss
    
    func dismissAlert() {
        containerViewController?.dismiss(animated: true, completion: {
            self.alertDismissed()
        })
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        //Called when a standard alert is dismissed
        super.dismiss(animated: flag) {
            completion?()

            self.alertDismissed()
        }
    }
    
    private func alertDismissed() {
        delegate?.viewController(self, didDismissAlert: alertViewController)
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomAlertPresentAnimationController()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomAlertDismissAnimationController()
    }
}

fileprivate class CustomAlertContainerViewController: UIViewController, UIViewControllerTransitioningDelegate {
    private let childViewController: UIViewController
    
    // MARK: - Init
    
    init(withChildViewController childViewController: UIViewController) {
        self.childViewController = childViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewLifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.75)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backgroundView)
        
        childViewController.view.translatesAutoresizingMaskIntoConstraints = false
        add(childViewController)
        
        NSLayoutConstraint.activate([
            childViewController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            childViewController.view.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            childViewController.view.widthAnchor.constraint(lessThanOrEqualToConstant: 300.0),
            childViewController.view.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
            backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.rightAnchor.constraint(equalTo: view.rightAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

fileprivate class CustomAlertPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    // MARK: - UIViewControllerAnimatedTransitioning
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to),
            let snapshot = toViewController.view.snapshotView(afterScreenUpdates: true)
            else {
                return
        }
        
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toViewController)
        
        snapshot.frame = finalFrame
        snapshot.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        snapshot.alpha = 0.0
        
        containerView.addSubview(toViewController.view)
        containerView.addSubview(snapshot)
        toViewController.view.isHidden = true
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, animations: {
            snapshot.alpha = 1.0
            snapshot.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }) { _ in
            toViewController.view.isHidden = false
            snapshot.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

fileprivate class CustomAlertDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from),
            let snapshot = fromViewController.view.snapshotView(afterScreenUpdates: true)
            else {
                return
        }
        
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: fromViewController)
        
        snapshot.frame = finalFrame
        
        containerView.addSubview(snapshot)
        fromViewController.view.isHidden = true
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, animations: {
            snapshot.alpha = 0.0
        }) { _ in
            snapshot.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
