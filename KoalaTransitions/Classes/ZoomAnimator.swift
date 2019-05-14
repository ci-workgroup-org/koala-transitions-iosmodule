//  ZoomAnimator.swift
//  KoalaTransitions
//
//  Created by nick@fuzzproductions.com on 05/13/2019.
//  Copyright (c) 2019 nick@fuzzproductions.com. All rights reserved.
//

import UIKit

public class ZoomAnimator: NSObject, Animator {
    public let duration = 3.0
    public var reversed: Bool
    public let originFrame: CGRect
    public var dismissCompletion: (() -> Void)?

    public init(_ originFrame: CGRect = CGRect.zero, reversed: Bool = false) {
        self.originFrame = originFrame
        self.reversed = reversed
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
        if reversed {
             initialFrame = fromView.frame
             finalFrame = originFrame
            
            let xScaleFactor = finalFrame.width / initialFrame.width
            
            let yScaleFactor = finalFrame.height / initialFrame.height

             scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        } else {
            
            initialFrame = originFrame
            finalFrame = fromView.frame
            
            let xScaleFactor =
                initialFrame.width / finalFrame.width
            
            let yScaleFactor =
                initialFrame.height / finalFrame.height
            

            scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        }
        

        if !reversed {
            fromView.transform = scaleTransform
            fromView.center = CGPoint(
                x: initialFrame.midX,
                y: initialFrame.midY
            )
            fromView.clipsToBounds = true
        }

        containerView.addSubview(toView)
        if reversed {
            containerView.bringSubview(toFront: fromView)
        }

        UIView.animate(withDuration: duration,
                       delay: 0.0,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 0.0,
                       animations: {
                            if reserved {
                                fromView.transform = scaleTransform
                                fromView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
                            } else {
                                toView.transform = scaleTransform
                                toView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
                            }
                       },
                       completion: { _ in
                           transitionContext.completeTransition(true)
                        }
        )
    }
}
