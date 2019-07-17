//  MatchedElementsAnimator.swift
//  KoalaTransitions
//
//  Created by nick@fuzzproductions.com on 05/13/2019.
//  Copyright (c) 2019 nick@fuzzproductions.com. All rights reserved.
//

import UIKit

internal func timeStampedPrint(_ object: Any? = nil, line: Int = #line, function: String = #function) {
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm:ss.SSS"
    let timeString = formatter.string(from: Date())
    if let object = object {
        print("[Transitioner][\(function):\(line)]@\(timeString): \(object)")
    } else {
        print("[Transitioner][\(function):\(line)]@\(timeString): nil")
    }
}

public class MatchedElementsAnimator: NSObject, Animator {
    public let duration: Double

    public var playDirection: AnimationDirection = .forward
    public var supportedPresentations = PresentaionType.all

    public var elementPairs: [ElementPair]
    public let originFrame: CGRect

    public init(_ originFrame: CGRect = CGRect.zero, elementPairs: [ElementPair], duration: Double = 0.40) {
        self.elementPairs = elementPairs
        self.duration = duration
        self.originFrame = originFrame
    }

    public func transitionDuration(using _: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView

        guard let toView = transitionContext.view(forKey: .to),
            let fromView = transitionContext.view(forKey: .from)
        else { return }

        switch playDirection {
        case .forward:

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
                timeStampedPrint("a view had a zero frame")
                toView.setNeedsLayout()
                toView.setNeedsUpdateConstraints()
                toView.layoutIfNeeded()
                toView.updateConstraintsIfNeeded()
            }

            let animatableViews = elementPairs.map { SnapshottedElementPair(pair: $0) }
            animatableViews.forEach { containerView.addSubview($0.imageView) }

            // hide original animating views
            elementPairs.hideOriginViews()

            UIView.animate(
                withDuration: duration,
                animations: {
                    toView.transform = CGAffineTransform.identity
                    toView.center = endingCenter

                    animatableViews.animateFrame(direction: self.playDirection)
                },
                completion: { _ in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                    /// reset the original view
                    self.elementPairs.showOriginViews()
                    animatableViews.removeSnapshotViews()
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                }
            )

            UIView.animate(
                withDuration: duration * 0.4, delay: duration * 0.6,
                animations: {
                    toView.alpha = 1.0
                    animatableViews.animateOpacity(direction: self.playDirection)
                }
            )

        case .backward:
            let scalingTransform: CGAffineTransform
            let finalFrame = originFrame

            scalingTransform = finalFrame.scaleTransform(to: fromView.frame)

            containerView.addSubview(toView)
            containerView.addSubview(fromView)

            let animatableViews = elementPairs.map { SnapshottedElementPair(pair: $0) }
            animatableViews.forEach { containerView.addSubview($0.imageView) }

            let dismissDuration = duration * 0.75
            UIView.animate(
                withDuration: dismissDuration * 0.6,
                animations: {
                    fromView.alpha = 0.0
                    self.elementPairs.showOriginViews()
                    animatableViews.animateOpacity(direction: self.playDirection)
                }
            )

            UIView.animate(
                withDuration: dismissDuration,
                animations: {
                    fromView.transform = scalingTransform
                    fromView.center = finalFrame.center

                },
                completion: { _ in
                    animatableViews.removeSnapshotViews()
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                }
            )
        }
    }
}
