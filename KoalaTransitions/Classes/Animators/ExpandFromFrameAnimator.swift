//  ExpandFromFrameAnimator.swift
//  KoalaTransitions
//
//  Created by Nicholas Trienens on 5/14/19.
//

import UIKit

/// ExpandFromFrameAnimator takes an intial Frame and animates the incoming ViewController
/// from that `originFrame` to the final size, reversable
public class ExpandFromFrameAnimator: NSObject, Animator {
    public let duration: Double
    public let originFrame: CGRect
    public var playDirection: AnimationDirection

    public var supportedPresentations = PresentaionType.all

    public init(_ originFrame: CGRect = CGRect.zero, duration: Double = 0.40) {
        self.originFrame = originFrame
        playDirection = .forward
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

        switch playDirection {
        case .forward:
            UIView.animate(
                withDuration: duration,
                animations: {
                    toView.transform = CGAffineTransform.identity
                    toView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)

                },
                completion: { _ in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                }
            )

        case .backward:
            UIView.animate(
                withDuration: duration * 0.9,
                animations: {
                    fromView.transform = scaleTransform
                    fromView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)

                },
                completion: { _ in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                }
            )

            UIView.animate(withDuration: duration * 0.6, delay: duration * 0.4, animations: {
                fromView.alpha = 0.5
            })
        }
    }
}
