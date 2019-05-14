//  ZoomAnimator.swift
//  KoalaTransitions
//
//  Created by nick@fuzzproductions.com on 05/13/2019.
//  Copyright (c) 2019 nick@fuzzproductions.com. All rights reserved.
//

import UIKit

public class ZoomAnimator: NSObject, Animator {
    public let duration = 3.0
    public var playDirection: AnimationDirection
    public let originFrame: CGRect

    public init(_ originFrame: CGRect = CGRect.zero, direction: AnimationDirection = .forward) {
        self.originFrame = originFrame
        playDirection = direction
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

        case .backward:
            initialFrame = fromView.frame
            finalFrame = originFrame

            let xScaleFactor = finalFrame.width / initialFrame.width

            let yScaleFactor = finalFrame.height / initialFrame.height

            scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)

//            toView.transform = scaleTransform
//            toView.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
//            toView.clipsToBounds = true
        }
        containerView.addSubview(toView)

        UIView.animate(withDuration: duration,
                       delay: 0.0,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 0.0,
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
                           transitionContext.completeTransition(true)
        })
    }
}
