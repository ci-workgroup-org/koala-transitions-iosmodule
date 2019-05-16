//
import Foundation
//  Transitioner.swift
//  KoalaTransitions
//
//  Created by boulder on 5/13/19.
//
import UIKit

/// Tranisioner holds reference to the animator, and can be set as
/// the `transitioningDelegate` on any UIViewController
/// updates the 'playDirection' based on the presentation method called
public class Transitioner: NSObject, UIViewControllerTransitioningDelegate {
    public let animator: Animator

    /// foward the play direction to the backing animator
    public var playDirection: AnimationDirection {
        get {
            return animator.playDirection
        }
        set {
            animator.playDirection = newValue
        }
    }

    public override var debugDescription: String {
        return "[Transitioner] direction: \(playDirection) animator: \(animator.debugDescription ?? "")"
    }

    public init(animator: Animator) {
        self.animator = animator
    }

    // MARK: - `UIViewControllerTransitioningDelegate` -

    public func animationController(
        forPresented _: UIViewController,
        presenting _: UIViewController,
        source _: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        if animator.supportedPresentations.contains(.present) {
            playDirection = .forward
            return animator
        } else {
            return nil
        }
    }

    public func animationController(forDismissed _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if animator.supportedPresentations.contains(.dismiss) {
            playDirection = .backward
            return animator
        } else {
            return nil
        }
    }
}

// MARK: - `UINavigationControllerDelegate` -

extension Transitioner: UINavigationControllerDelegate {
    public func navigationController(_: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from _: UIViewController, to _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if animator.supportedPresentations.contains(.push), operation == .push {
            playDirection = .forward
            return animator
        } else if animator.supportedPresentations.contains(.pop), operation == .pop {
            playDirection = .backward
            return animator
        }
        return nil
    }
}

/// InOutTransitioner holds reference to  two animators, a In and an Out
/// inAnimator will always be set to playDirection `.forward` and outAnimator to `.backward`
public class InOutTransitioner: Transitioner {
    let outAnimator: Animator

    public init(inAnimator: Animator, outAnimator: Animator) {
        self.outAnimator = outAnimator
        outAnimator.playDirection = .backward
        super.init(animator: inAnimator)
    }

    public override func animationController(forDismissed _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return outAnimator
    }
}
