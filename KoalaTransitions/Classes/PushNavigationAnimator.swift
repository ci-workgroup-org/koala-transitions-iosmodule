//
//  PTNPushNavigationAnimator.swift
//  ThePattern
//
//  Created by nicholas Trienens on 2/10/16.
//  Copyright © 2016 Fuzz Productions. All rights reserved.
//

import Foundation
import UIKit

public enum TargetPanDirection {
    case fromLeftToRight
    case fromTopToBottom
    case fromRightToLeft
    case fromBottomToTop
}

public class PushNavigationAnimator: NSObject, Animator {
    var direction: TargetPanDirection
    public var playDirection: AnimationDirection = .forward

    public init(direction: TargetPanDirection = .fromRightToLeft) {
        self.direction = direction
    }

    public func transitionDuration(using _: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }

    public func animateTransition(using context: UIViewControllerContextTransitioning) {
        guard let toViewController = context.viewController(forKey: UITransitionContextViewControllerKey.to),
            let fromViewController = context.viewController(forKey: UITransitionContextViewControllerKey.from) else { return }

        switch playDirection {
        case .forward:
            context.containerView.addSubview(toViewController.view)

            switch direction {
            case .fromLeftToRight:
                toViewController.view.transform = CGAffineTransform(translationX: -toViewController.view.bounds.size.width, y: 0)
            case .fromTopToBottom:
                toViewController.view.transform = CGAffineTransform(translationX: 0, y: -toViewController.view.bounds.size.height)
            case .fromBottomToTop:
                toViewController.view.transform = CGAffineTransform(translationX: 0, y: toViewController.view.bounds.size.height)
            case .fromRightToLeft:
                toViewController.view.transform = CGAffineTransform(translationX: toViewController.view.bounds.size.width, y: 0)
            }

            UIView.animate(
                withDuration: transitionDuration(using: context),
                animations: {
                    toViewController.view.transform = CGAffineTransform(translationX: 0, y: 0)
                },
                completion: { _ in
                    toViewController.view.transform = CGAffineTransform(translationX: 0, y: 0)
                    context.completeTransition(!context.transitionWasCancelled)
                }
            )
        case .backward:
            context.containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
            var transform: CGAffineTransform
            switch direction {
            case .fromLeftToRight:
                transform = CGAffineTransform(translationX: -toViewController.view.bounds.size.width, y: 0)
            case .fromTopToBottom:
                transform = CGAffineTransform(translationX: 0, y: -toViewController.view.bounds.size.height)
            case .fromBottomToTop:
                transform = CGAffineTransform(translationX: 0, y: toViewController.view.bounds.size.height)
            case .fromRightToLeft:
                transform = CGAffineTransform(translationX: toViewController.view.bounds.size.width, y: 0)
            }

            UIView.animate(
                withDuration: transitionDuration(using: context),
                animations: {
                    fromViewController.view.transform = transform
                },
                completion: { _ in
                    fromViewController.view.transform = transform
                    fromViewController.view.removeFromSuperview()
                    context.completeTransition(!context.transitionWasCancelled)
                }
            )
        }
    }
}
