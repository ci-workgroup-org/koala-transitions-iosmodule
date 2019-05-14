//
//  CustomTransitions.swift
//  KoalaTransitions
//
//  Created by Nicholas Trienens on 5/14/19.
//

import Foundation
import UIKit

/// ViewControllers conforming to this protocol manage the lifecycle
/// of their presented Transitioner and can call the convience method
/// `dismissWithTransition` to dismiss using that transition
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

    public func dismissWithTransition(completion: (() -> Void)? = nil) {
        if let transitioner = transitioner {
            transitioningDelegate = transitioner
        }
        dismiss(animated: true, completion: completion)
    }

    public func popWithTransition(completion _: (() -> Void)? = nil) {
        if let transitioner = transitioner {
            transitioner.playDirection = .backward
            transitioningDelegate = transitioner
        }
        navigationController?.popViewController(animated: true)
    }
}
