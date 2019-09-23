//
//  PushSlideAnimator.swift
//  KoalaTransitions
//
//  Created by Nicholas Trienens on 5/14/19.
//

import Foundation
import UIKit

/// SlideAnimator does a push that moves the existing ViewController off left as the new viewcController
/// enteres from the right, reversable
open class PagedSlideAnimator: NSObject, Animator {
    public var animationComplete: ((AnimationDirection) -> Void)?

    public let duration: Double
    public var playDirection: AnimationDirection = .forward
    public var supportedPresentations = PresentaionType.all

    /// adjusts the leaving view's movment speed, 1 is equal movement
    /// higher numbers slow the animation speed thus allowing the incoming
    /// controller to overlap
    public var overTakeRatio: CGFloat = 1.15

    open override var debugDescription: String {
        return "PagedSlideAnimator: \(playDirection)"
    }

    public init(duration: Double = 0.3) {
        self.duration = duration
    }

    open func transitionDuration(using _: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    open func animateTransition(using context: UIViewControllerContextTransitioning) {
        guard let toView = context.view(forKey: UITransitionContextViewKey.to),
            let fromView = context.view(forKey: UITransitionContextViewKey.from) else { return }

        switch playDirection {
        case .forward:
            context.containerView.addSubview(toView)
            toView.transform = CGAffineTransform(translationX: toView.width, y: 0)

            UIView.animate(
                withDuration: transitionDuration(using: context),
                animations: {
                    toView.transform = CGAffineTransform(translationX: 0, y: 0)
                    fromView.transform = CGAffineTransform(translationX: -fromView.width / self.overTakeRatio, y: 0)
                },
                completion: { _ in
                    fromView.transform = CGAffineTransform(translationX: 0, y: 0)
                    toView.transform = CGAffineTransform(translationX: 0, y: 0)
                    context.completeTransition(!context.transitionWasCancelled)
                }
            )
        case .backward:
            context.containerView.insertSubview(toView, aboveSubview: fromView)
            toView.transform = CGAffineTransform(translationX: -toView.width, y: 0)

            UIView.animate(
                withDuration: transitionDuration(using: context),
                animations: {
                    fromView.transform = CGAffineTransform(translationX: fromView.width / self.overTakeRatio, y: 0)
                    toView.transform = CGAffineTransform(translationX: 0, y: 0)
                },
                completion: { _ in
                    fromView.removeFromSuperview()
                    context.completeTransition(!context.transitionWasCancelled)
                }
            )
        }
    }
}
