//
//  SlideAnimator.swift
//  KoalaTransitions
//
//  Created by Nicholas Trienens on 5/14/19.
//  Copyright (c) 2019 nick@fuzzproductions.com. All rights reserved.

import Foundation
import UIKit

/// SlideDirection represents the directionality of the SlideAnimator transition
public enum SlideDirection {
    case fromLeftToRight
    case fromTopToBottom
    case fromRightToLeft
    case fromBottomToTop
}

/// SlideAnimator does a mock push but from any of the 4 screen edges
/// doesn't move the existing ViewController
public class SlideAnimator: NSObject, Animator {
    public var animationComplete: ((AnimationDirection) -> Void)?

    public let direction: SlideDirection
    public let duration: Double
    public var playDirection: AnimationDirection = .forward
    public var supportedPresentations = PresentaionType.all

    public override var debugDescription: String {
        return "SlideAnimator: \(playDirection) direction: \(direction)"
    }

    public init(direction: SlideDirection = .fromRightToLeft, duration: Double = 0.3) {
        self.direction = direction
        self.duration = duration
    }

    public func transitionDuration(using _: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
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

                    context.completeTransition(true)
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
                    context.completeTransition(true)
                }
            )
        }
    }
}
