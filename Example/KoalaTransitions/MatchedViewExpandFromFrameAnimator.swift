//  MatchedItemsExpandFromFrameAnimator.swift
//  KoalaTransitions
//
//  Created by nick@fuzzproductions.com on 05/13/2019.
//  Copyright (c) 2019 nick@fuzzproductions.com. All rights reserved.
//

import KoalaTransitions
import UIKit

public class MatchedViewExpandFromFrameAnimator: NSObject, Animator {
    public let duration: Double
    public let originFrame: CGRect
    public let originImageView: UIImageView
    public let originView: UIView
    public let finalView: UIView

    public var playDirection: AnimationDirection
    public var supportedPresentations = PresentaionType.all

    public init(_ originFrame: CGRect = CGRect.zero, originView: UIView, finalView: UIView, duration: Double = 0.40) {
        self.originFrame = originFrame
        self.finalView = finalView
        self.originView = originView

        originImageView = UIImageView(image: originView.snapshot())
        originImageView.contentMode = .scaleToFill

        self.duration = duration
        playDirection = .forward
    }

    public func transitionDuration(using _: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func scaleTransform(from: CGRect, to: CGRect) -> CGAffineTransform {
        let xScaleFactor = from.width / to.width
        let yScaleFactor = from.height / to.height
        return CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView

        guard let toView = transitionContext.view(forKey: .to),
            let fromView = transitionContext.view(forKey: .from)
        else { return }

        let initialFrame: CGRect
        let finalFrame: CGRect
        let scalingTransform: CGAffineTransform

        switch playDirection {
        case .forward:

            print(originView)
            originView.alpha = 0
            originView.isHidden = true

            initialFrame = originFrame
            finalFrame = toView.frame
            toView.alpha = 0.0

            toView.layoutIfNeeded()
            toView.updateConstraints()
            toView.setNeedsLayout()
            toView.layoutIfNeeded()

            let underImageView = UIImageView(image: fromView.snapshot())
            containerView.addSubview(underImageView)
            underImageView.frame = fromView.frame

            let finalViewFrame: CGRect
            if let view = toView.subviews.first(where: { $0 == self.finalView }) {
                finalViewFrame = view.frameInSuperview
            } else {
                finalViewFrame = finalFrame
            }

            scalingTransform = scaleTransform(from: initialFrame, to: finalFrame)
            toView.transform = scalingTransform
            toView.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
            toView.clipsToBounds = true
            containerView.addSubview(toView)

            originImageView.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
            containerView.addSubview(originImageView)

            UIView.animate(
                withDuration: duration,
                animations: {
                    toView.transform = CGAffineTransform.identity
                    toView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)

                    let imageScaleTransform = self.scaleTransform(from: finalViewFrame, to: self.originFrame)
                    self.originImageView.transform = imageScaleTransform
                    self.originImageView.center = CGPoint(x: finalViewFrame.midX, y: finalViewFrame.midY)

                },
                completion: { _ in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                    /// reset the original view
                    self.originView.alpha = 1
                    self.originView.isHidden = false
                }
            )

            UIView.animate(
                withDuration: duration * 0.4, delay: duration * 0.6,
                animations: {
                    self.originImageView.alpha = 0.0
                    toView.alpha = 1.0
                },
                completion: { _ in self.originImageView.removeFromSuperview() }
            )

        case .backward:
            initialFrame = fromView.frame
            finalFrame = originFrame

            let xScaleFactor = finalFrame.width / initialFrame.width

            let yScaleFactor = finalFrame.height / initialFrame.height
            scalingTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)

            containerView.addSubview(toView)
            containerView.addSubview(fromView)

            let finalViewFrame: CGRect
            if let view = fromView.subviews.first(where: { $0 == self.finalView }) {
                finalViewFrame = view.frameInSuperview
            } else {
                finalViewFrame = finalFrame
            }

            let imageScaleTransform = scaleTransform(from: finalViewFrame, to: originFrame)
            originImageView.transform = imageScaleTransform
            originImageView.center = CGPoint(x: finalViewFrame.midX, y: finalViewFrame.midY)
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
                    fromView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)

                    self.originImageView.transform = CGAffineTransform.identity
                    self.originImageView.center = CGPoint(x: self.originFrame.midX, y: self.originFrame.midY)

                },
                completion: { _ in
                    self.originImageView.removeFromSuperview()
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                }
            )
        }
    }
}
