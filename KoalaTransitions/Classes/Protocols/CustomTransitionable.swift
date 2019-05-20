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
public protocol CustomTransitionable: UIViewController {
    var transitioner: Transitioner? { get set }
}

extension CustomTransitionable {
    public func setTransitioner(_ transitioner: Transitioner?) {
        self.transitioner = transitioner
        transitioningDelegate = transitioner
    }

    public func setTransitioningDelegateToTransitioner() {
        transitioningDelegate = transitioner
        if let navController = self as? UINavigationController {
            navController.delegate = transitioner
        }
    }

    public func dismissWithTransition(completion: (() -> Void)? = nil) {
        setTransitioningDelegateToTransitioner()
        dismiss(animated: true, completion: completion)
    }
}

extension UIViewController {
    public func present(_ viewControllerToPresent: UIViewController & CustomTransitionable, transition transitioner: Transitioner, completion: (() -> Void)? = nil) throws {
        transitioner.playDirection = .forward
        viewControllerToPresent.transitioner = transitioner
        viewControllerToPresent.setTransitioningDelegateToTransitioner()
        present(viewControllerToPresent, animated: true, completion: {
            completion?()
        })
    }
}
