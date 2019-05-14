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

/// PresentaionType represents the types of animation
public struct PresentaionType: OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    static let present = PresentaionType(rawValue: 1 << 0)
    static let push = PresentaionType(rawValue: 1 << 2)
    static let dismiss = PresentaionType(rawValue: 1 << 4)
    static let pop = PresentaionType(rawValue: 1 << 8)

    static let all: PresentaionType = [.present, .push, .dismiss, .pop]
}

public protocol Animator: UIViewControllerAnimatedTransitioning {
    var playDirection: AnimationDirection { get set }
    var supportedPresentations: PresentaionType { get }
}
