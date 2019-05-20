//
//  ElementMatching.swift
//  KoalaTransitions
//
//  Created by Nicholas Trienens on 5/17/19.
//

import Foundation
import UIKit

/// ViewControllers conforming to this protocol are expected
/// to provide a set of elements for animation, these elements
/// are them attempted to be matched to the presenting controllers elements
public protocol ElementMatching: UIViewController {
    func elements() -> [ElementInterface]
}

public protocol ElementInterface {
    var view: UIView { get }
}

public protocol Matchable {
//    static func == (lhs: Matchable, rhs: Matchable) -> Bool
}

/// This struct is returned from the viewController to be presented
/// then should be transitioned into a ViewPair
public struct Element<Identifier: Matchable>: ElementInterface {
    public let view: UIView
    public let usage: Identifier

    public init(view: UIView, use: Identifier) {
        self.view = view
        usage = use
    }
}

extension Element {
    public static func == <LeftIdentifier, RightIdentifier>(lhs: Element<LeftIdentifier>, rhs: Element<RightIdentifier>) -> Bool {
        guard let leftUsage = lhs.usage, let rightUsage = rhs.usage as? LeftIdentifier else { return false }
        return leftUsage == rightUsage
    }
}

public struct ElementPair<Identifier: Equatable> {
    let fromView: UIView
    let finalView: UIView
    let usage: Identifier
    let shouldScale: Bool

    public init(fromView: UIView, finalView: UIView, use: Identifier, shouldScale: Bool = true) {
        self.fromView = fromView
        self.finalView = finalView
        usage = use
        self.shouldScale = shouldScale
    }
}
