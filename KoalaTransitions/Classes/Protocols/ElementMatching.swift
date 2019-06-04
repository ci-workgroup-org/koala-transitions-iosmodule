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
    func matchesUsage(other: ElementInterface) -> Bool
    func createPair(_ element: ElementInterface) -> ElementPair
}

public protocol Matchable {
//    static func == (lhs: Matchable, rhs: Matchable) -> Bool
}

/// This struct is returned from the viewController to be presented
/// then should be transitioned into a ViewPair
public struct Element<Identifier: Equatable>: ElementInterface {
    public let view: UIView
    public let usage: Identifier

    public init(view: UIView, use: Identifier) {
        self.view = view
        usage = use
    }

    public func matchesUsage(other: ElementInterface) -> Bool {
        guard let other = other as? Element,
            let otherUsage = other.usage as? Identifier else { return false }
        return otherUsage == usage
    }

    public func createPair(_ element: ElementInterface) -> ElementPair {
        return ElementPair(fromView: view, finalView: element.view, shouldScale: false)
    }
}

public struct ElementPair {
    let fromView: UIView
    let finalView: UIView
    let shouldScale: Bool

    public init(fromView: UIView, finalView: UIView, shouldScale: Bool = true) {
        self.fromView = fromView
        self.finalView = finalView
        self.shouldScale = shouldScale
    }
}

public struct SnapshottedElementPair {
    let pair: ElementPair
    let imageView: UIImageView

    public init(pair: ElementPair) {
        self.pair = pair

        print(pair.fromView)
        imageView = UIImageView(image: pair.fromView.snapshot())
        imageView.frame = pair.fromView.frameInSuperview
    }
}

extension Collection where Element == ElementPair {
    public func hideOriginViews() {
        forEach { $0.fromView.alpha = 0 }
    }

    public func showOriginViews() {
        forEach { $0.fromView.alpha = 1 }
    }

    public func hasZeroFramedViews() -> Bool {
        return reduce(false) { (current, view) -> Bool in
            current || view.finalView.frame == CGRect.zero
        }
    }
}

extension Collection where Element == SnapshottedElementPair {
    public func animateFrame(direction: AnimationDirection) {
        forEach {
            switch direction {
            case .forward:
                let imageScaleTransform = $0.pair.finalView.frameInSuperview
                    .scaleTransform(to: $0.pair.fromView.frameInSuperview)
                print(imageScaleTransform)
                $0.imageView.transform = imageScaleTransform
                $0.imageView.center = $0.pair.finalView.frameInSuperview.center
            case .backward:
                let imageScaleTransform = $0.pair.finalView.frameInSuperview
                    .scaleTransform(to: $0.pair.fromView.frameInSuperview)
                $0.imageView.transform = imageScaleTransform
                $0.imageView.center = $0.pair.fromView.frameInSuperview.center
            }
        }
    }

    public func animateOpacity(direction: AnimationDirection) {
        forEach {
            switch direction {
            case .forward:
                $0.imageView.alpha = 0
            case .backward:
                $0.imageView.alpha = 1
            }
        }
    }

    public func removeSnapshotViews() {
        forEach { $0.imageView.removeFromSuperview() }
    }
}

extension Array where Element == ElementInterface {
    public func matchPairs(_ otherArray: [Element]) -> [ElementPair] {
        guard count <= otherArray.count else {
            return []
        }

        return flatMap { item in
            otherArray.compactMap {
                if item.matchesUsage(other: $0) {
                    return item.createPair($0)
                } else {
                    return nil
                }
            }
        }
    }
}

extension Array {
    public func zip<T>(_ otherArray: [Element], combiner: (Element, Element) -> T) -> [T] {
        guard count <= otherArray.count else {
            return []
        }
        var index = 0
        return map { item -> T in
            let otherItem = otherArray[index]
            index += 1
            return combiner(item, otherItem)
        }
    }
}
