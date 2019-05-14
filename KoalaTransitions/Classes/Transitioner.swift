//
//  Transitioner.swift
//  KoalaTransitions
//
//  Created by boulder on 5/13/19.
//

import Foundation
import UIKit

public class Transitioner: NSObject, UIViewControllerTransitioningDelegate {
    public var originFrame = CGRect.zero
    public let animator: UIViewControllerAnimatedTransitioning

    public init(animator: UIViewControllerAnimatedTransitioning) {
        self.animator = animator
    }

    public func animationController(forPresented _: UIViewController, presenting _: UIViewController, source _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }

    public func animationController(forDismissed _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }
}
