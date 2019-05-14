//
import Foundation
//  Transitioner.swift
//  KoalaTransitions
//
//  Created by boulder on 5/13/19.
//
import UIKit

public class Transitioner: NSObject, UIViewControllerTransitioningDelegate {
    public let animator: Animator

    public var playDirection: AnimationDirection {
        get {
            return animator.playDirection
        }
        set {
            animator.playDirection = newValue
        }
    }

    public init(animator: Animator) {
        self.animator = animator
    }

    public func animationController(forPresented _: UIViewController, presenting _: UIViewController, source _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }

    public func animationController(forDismissed _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }
}
