//  MatchedItemsExpandFromFrameAnimator.swift
//  KoalaTransitions
//
//  Created by nick@fuzzproductions.com on 05/13/2019.
//  Copyright (c) 2019 nick@fuzzproductions.com. All rights reserved.
//

import UIKit

public class MatchedViewExpandFromFrameAnimator: NSObject, Animator {
    public let duration: Double
    public let originFrame: CGRect
    public let originImageView: UIImageView
    public let originView: UIView?
    public let finalView: UIView

    public var playDirection: AnimationDirection
    public var supportedPresentations = PresentaionType.all

    /// Create an MatchedViewExpandFromFrameAnimator to zoom the incoming viewController for a view, creates a snapshot of the originView to animate
    ///
    /// - Parameters:
    ///   - originFrame: frame to start the animation from
    ///   - originView: optional origin view
    ///   - originSnapshot: UIImage
    ///   - finalView: UIImage
    ///   - duration: time for the animation to occur over
    public init(
        _ originFrame: CGRect = CGRect.zero,
        originView: UIView? = nil,
        originSnapshot: UIImage? = nil,
        finalView: UIView,
        duration: Double = 0.40
    ) {
        self.originFrame = originFrame
        self.finalView = finalView
        self.originView = originView

        originImageView = UIImageView(image: originSnapshot ?? originView?.snapshot())
        originImageView.contentMode = .scaleToFill

        originImageView.frame = originFrame

        self.duration = duration
        playDirection = .forward
    }

    deinit {
        self.originView?.alpha = 1
    }

    public func transitionDuration(using _: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView

        guard let toView = transitionContext.viewController(forKey: .to)?.view,
            let fromView = transitionContext.viewController(forKey: .from)?.view,
            let toViewController = transitionContext.viewController(forKey: .to)
        else { return }

        let initialFrame: CGRect
        let finalFrame: CGRect
        let scalingTransform: CGAffineTransform

        switch playDirection {
        case .forward:

            originView?.alpha = 0

            initialFrame = originFrame
            finalFrame = toView.frame
            toView.alpha = 0.0

            let underImageView = UIImageView(image: fromView.snapshot())
            containerView.addSubview(underImageView)
            underImageView.frame = fromView.frame

            if finalView.frame == .zero {
                toView.setNeedsLayout()
                toView.setNeedsUpdateConstraints()
                toView.layoutIfNeeded()
                toView.updateConstraintsIfNeeded()
            }

            let finalViewFrame: CGRect
            if let toViewController = toViewController as? UINavigationController,
                let firstViewController = toViewController.viewControllers.first,
                let view = firstViewController.view.subviews.first(where: { $0 == self.finalView }) {
                finalViewFrame = view.frameInSuperview

            } else if let view = toView.subviews.first(where: { $0 == self.finalView }) {
                finalViewFrame = view.frameInSuperview
            } else {
                finalViewFrame = finalFrame
            }

            scalingTransform = initialFrame.scaleTransform(to: finalFrame)
            toView.transform = scalingTransform
            toView.center = initialFrame.center
            toView.clipsToBounds = true
            containerView.addSubview(toView)

            originImageView.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
            containerView.addSubview(originImageView)

            UIView.animate(
                withDuration: duration,
                animations: {
                    toView.transform = CGAffineTransform.identity
                    toView.center = finalFrame.center

                    let imageScaleTransform = finalViewFrame.scaleTransform(to: self.originFrame)
                    self.originImageView.transform = imageScaleTransform
                    self.originImageView.center = finalViewFrame.center
                }
            )

            originView?.alpha = 0
            UIView.animate(
                withDuration: duration * 0.3, delay: duration * 0.7,
                animations: {
                    self.originImageView.alpha = 0.0
                }
            )

            UIView.animate(
                withDuration: duration * 0.4, delay: duration * 0.6,
                animations: {
                    toView.alpha = 1.0
                },
                completion: { _ in
                    self.originImageView.removeFromSuperview()
                }
            )

        case .backward:
            initialFrame = fromView.frame
            finalFrame = originFrame

            scalingTransform = finalFrame.scaleTransform(to: initialFrame)

            containerView.addSubview(toView)
            containerView.addSubview(fromView)

            let finalViewFrame: CGRect
            if let view = fromView.subviews.first(where: { $0 == self.finalView }) {
                finalViewFrame = view.frameInSuperview
            } else {
                finalViewFrame = finalFrame
            }

            let imageScaleTransform = finalViewFrame.scaleTransform(to: originFrame)
            originImageView.transform = imageScaleTransform
            originImageView.center = finalViewFrame.center
            containerView.addSubview(originImageView)

            let dismissDuration = duration * 0.75
            UIView.animate(
                withDuration: dismissDuration * 0.6,
                animations: {
                    self.originImageView.alpha = 1.0
                    fromView.alpha = 0.0
                }
            )

            UIView.animate(
                withDuration: dismissDuration,
                animations: {
                    fromView.transform = scalingTransform
                    fromView.center = finalFrame.center

                    self.originImageView.transform = CGAffineTransform.identity
                    self.originImageView.center = self.originFrame.center

                },
                completion: { _ in
                    self.originImageView.removeFromSuperview()
                    /// reset the original view
                    self.originView?.alpha = 1
                }
            )
        }
    }
}
