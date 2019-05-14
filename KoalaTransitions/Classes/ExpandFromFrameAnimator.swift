//  ExpandFromFrameAnimator.swift
//  KoalaTransitions
//
//  Created by nick@fuzzproductions.com on 05/13/2019.
//  Copyright (c) 2019 nick@fuzzproductions.com. All rights reserved.
//

import UIKit


public class ExpandFromFrameAnimator: NSObject, Animator {
    public let duration: Double
    public let originFrame: CGRect
    
    public var playDirection: AnimationDirection

    public init(_ originFrame: CGRect = CGRect.zero, duration: Double = 0.40, direction: AnimationDirection = .forward) {
        self.originFrame = originFrame
        playDirection = direction
        self.duration = duration
    }

    public func transitionDuration(using _: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView

        guard let toView = transitionContext.view(forKey: .to),
            let fromView = transitionContext.view(forKey: .from)
        else { return }

        let initialFrame: CGRect
        let finalFrame: CGRect
        let scaleTransform: CGAffineTransform

        switch playDirection {
        case .forward:
            initialFrame = originFrame
            finalFrame = toView.frame

            let xScaleFactor = initialFrame.width / finalFrame.width
            let yScaleFactor = initialFrame.height / finalFrame.height
            scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)

            toView.transform = scaleTransform
            toView.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
            toView.clipsToBounds = true
            containerView.addSubview(toView)

        case .backward:
            initialFrame = fromView.frame
            finalFrame = originFrame

            let xScaleFactor = finalFrame.width / initialFrame.width

            let yScaleFactor = finalFrame.height / initialFrame.height
            scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)

            containerView.addSubview(toView)
            containerView.addSubview(fromView)
        }

        UIView.animate(withDuration: duration,
                       animations: {
                           switch self.playDirection {
                           case .forward:
                               toView.transform = CGAffineTransform.identity
                               toView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
                           case .backward:
                               fromView.transform = scaleTransform
                               fromView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
                           }
                       },
                       completion: { _ in
                           transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
