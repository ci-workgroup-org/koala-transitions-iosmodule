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
    public let duration: Double

    public init(duration: Double = 0.3) {
        self.duration = duration
    }

    public func transitionDuration(using _: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    public func animateTransition(using context: UIViewControllerContextTransitioning) {
        guard let fromView = context.view(forKey: .from),
            let toView = context.view(forKey: .to) else { return }

        let container = context.containerView
        switch playDirection {
        case .forward:
            container.addSubview(toView)
            toView.alpha = 0.0
            UIView.animate(withDuration: transitionDuration(using: context), animations: {
                toView.alpha = 1.0
            }, completion: { _ in context.completeTransition(true) })
        case .backward:
            container.insertSubview(toView, belowSubview: fromView)
            UIView.animate(withDuration: transitionDuration(using: context), animations: {
                fromView.alpha = 0.0
            }, completion: { _ in context.completeTransition(true) })
        }
    }
}
