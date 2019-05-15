//
//  CustomTransitions.swift
//  KoalaTransitions
//
//  Created by Nicholas Trienens on 5/14/19.
//

import Foundation
import UIKit

/// ViewControllers conforming to this protocol manage the lifecycle
/// of their presenting/dimissing Transitioner and can call the convience method
/// `dismissWithTransition` to dismiss using a transition
public protocol CustomTransitions: UIViewController {
    var transitioner: Transitioner? { get set }
}

extension CustomTransitions {
    public func setTransitioningDelegateToTransitioner() {
        transitioningDelegate = transitioner
        if let navController = self as? UINavigationController {
            navController.delegate = transitioner
        }
    }
}

extension UIViewController {
    public func present(_ viewControllerToPresent: UIViewController, transition transitioner: Transitioner, completion: (() -> Void)? = nil) {
        transitioner.playDirection = .forward
        transitioningDelegate = SelfRetainingTransitioner( transitioner)
        present(viewControllerToPresent, animated: true, completion: {
            completion?()
        })
    }

    public func dismiss(with transitioner: Transitioner, completion: (() -> Void)? = nil) {
        transitioner.playDirection = .backward
        transitioningDelegate = SelfRetainingTransitioner( transitioner)
        dismiss(animated: true, completion: {
            completion?()
        })
    }

    /// pop's the current view controller from it's NavigationStack
    /// NOTE: this overwrites the navigationController's `.delegate` property
    public func pop(with transitioner: Transitioner, completion _: (() -> Void)? = nil) {
        transitioner.playDirection = .backward
        navigationController?.delegate = SelfRetainingTransitioner( transitioner )
        navigationController?.popViewController(animated: true)
    }
}
