//  MatchedElementsAnimator.swift
//  KoalaTransitions
//
//  Created by nick@fuzzproductions.com on 05/13/2019.
//  Copyright (c) 2019 nick@fuzzproductions.com. All rights reserved.
//

import UIKit

public class MatchedElementsAnimator: NSObject, Animator {
    public let duration: Double

    public var playDirection: AnimationDirection = .forward
    public var supportedPresentations = PresentaionType.all

    public var elementPairs: [ElementPair]
    public let originFrame: CGRect

    ///  MatchedElementsAnimator,
    ///
    /// - Parameters:
    ///   - originFrame: frame to zoom in from
    ///   - elementPairs: an array of ElementPairs that match a origin view to  a final view for the animation
    ///   - duration: time for the animation to occur over
    public init(_ originFrame: CGRect = CGRect.zero, elementPairs: [ElementPair], duration: Double = 0.40) {
        self.elementPairs = elementPairs
        self.duration = duration
        self.originFrame = originFrame
    }

    public func transitionDuration(using _: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    public func animateTransition(using context: UIViewControllerContextTransitioning) {
        let containerView = context.containerView

        guard let toView = context.viewController(forKey: .to)?.view,
            let fromView = context.viewController(forKey: .from)?.view else { return }

        switch playDirection {
        case .forward:

            // hide original animating views
            elementPairs.forEach { pair in
                pair.fromView.alpha = 0
            }

            let underImageView = UIImageView(image: fromView.snapshot())
            containerView.addSubview(underImageView)
            underImageView.frame = fromView.frame

            toView.alpha = 0.0
            let endingCenter = toView.frame.center
            toView.transform = originFrame.scaleTransform(to: toView.frame)
            toView.center = originFrame.center
            toView.clipsToBounds = true
            containerView.addSubview(toView)

            if elementPairs.hasZeroFramedViews() {
                toView.setNeedsLayout()
                toView.setNeedsUpdateConstraints()
                toView.layoutIfNeeded()
                toView.updateConstraintsIfNeeded()
            }

            let animatableViews = elementPairs.map { SnapshottedElementPair(pair: $0) }
            animatableViews.forEach { containerView.addSubview($0.imageView) }

            UIView.animate(
                withDuration: duration,
                animations: {
                    toView.transform = CGAffineTransform.identity
                    toView.center = endingCenter

                    animatableViews.animateFrame(direction: self.playDirection)
                },
                completion: { _ in
                    animatableViews.removeSnapshotViews()
                    context.completeTransition(true)
                    underImageView.removeFromSuperview()
                }
            )

            UIView.animate(
                withDuration: duration * 0.4, delay: duration * 0.4,
                animations: {
                    toView.alpha = 1.0
                    animatableViews.animateOpacity(direction: self.playDirection)
                }
            )

        case .backward:
            let finalFrame = originFrame
            let scalingTransform = finalFrame.scaleTransform(to: fromView.frame)

            containerView.addSubview(toView)
            containerView.addSubview(fromView)

            // let animatableViews = elementPairs.map { SnapshottedElementPair(pair: $0) }
            // animatableViews.forEach { containerView.addSubview($0.imageView) }

            let dismissDuration = duration * 0.75
            elementPairs.showOriginViews(duration)
            UIView.animate(
                withDuration: dismissDuration * 0.4,
                delay: dismissDuration * 0.4,
                animations: {
                    fromView.alpha = 0.0
                    // animatableViews.animateOpacity(direction: self.playDirection)

                },
                completion: { _ in
                    context.completeTransition(true)
                }
            )

            UIView.animate(
                withDuration: dismissDuration,
                animations: {
                    fromView.transform = scalingTransform
                    fromView.center = finalFrame.center

                },
                completion: { _ in
                    // animatableViews.removeSnapshotViews()
                }
            )
        }
    }
}
