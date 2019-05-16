//
//  Animator.swift
//  KoalaTransitions
//
//  Created by Nicholas Trienens on 5/14/19.
//

import Foundation
import UIKit

/// AnimationDirection represents the direction of animation
public enum AnimationDirection {
    case forward
    case backward
}

/// PresentaionType represents the types of presentation to animate
public struct PresentaionType: OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    /// presenting modally from a viewController
    public static let present = PresentaionType(rawValue: 1 << 0)
    /// pushing on to a UINavigationController's stack
    public static let push = PresentaionType(rawValue: 1 << 1)
    /// dismissing modally
    public static let dismiss = PresentaionType(rawValue: 1 << 2)
    /// popping from a UINavigationController's stack
    public static let pop = PresentaionType(rawValue: 1 << 4)

    public static let all: PresentaionType = [.present, .push, .dismiss, .pop]
}

/// The `Animator` Protocol adds two variables to the UIViewControllerAnimatedTransitioning
/// allowing for better control of when and how an animation will be used
public protocol Animator: UIViewControllerAnimatedTransitioning {
    /// playDirection is set from the Transitioner based on the current transition
    /// while an animator not required to support backwards animations this property is required
    var playDirection: AnimationDirection { get set }
    /// there are four types of presentation, the Transitioner will check the current
    /// presentation against this set and only use the animator if supported
    var supportedPresentations: PresentaionType { get }
}

/// The `ReportsCompletion` Protocol adds two variables to the UIViewControllerAnimatedTransitioning
/// allowing for better control of when and how an animation will be used
public protocol CompletionReporter {
    var animationComplete: ((AnimationDirection) -> Void)? { get set }
}
