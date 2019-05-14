//
//  FadeAnimator.swift
//  KoalaTransitions
//
//  Created by Nicholas Trienens on 5/14/19.
//

import Foundation
import UIKit

public class FadeAnimator: NSObject, Animator {
    public var playDirection: AnimationDirection = .forward
    public var supportedPresentations = PresentaionType.all

    public func transitionDuration(using _: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to) else { return }

        let container = transitionContext.containerView
        switch playDirection {
        case .forward:
            container.addSubview(toView)
            toView.alpha = 0.0
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                toView.alpha = 1.0
            }, completion: { _ in
                let success = !transitionContext.transitionWasCancelled
                if !success {
                    toView.removeFromSuperview()
                }
                transitionContext.completeTransition(success)
            })
        case .backward:
            container.insertSubview(toView, belowSubview: fromView)
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                fromView.alpha = 0.0
            }, completion: { _ in
                let success = !transitionContext.transitionWasCancelled
                if !success {
                    toView.removeFromSuperview()
                }
                transitionContext.completeTransition(success)
            })
        }
    }
}
