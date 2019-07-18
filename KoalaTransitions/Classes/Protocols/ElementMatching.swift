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
    func elementsForAnimtion() -> [ElementInterface]
}

public protocol ElementInterface {
    var view: UIView { get }
    func matchesUsage(other: ElementInterface) -> Bool
    func createPair(_ element: ElementInterface) -> ElementPair
}

public protocol Matchable {}

/// This struct is returned from the viewController to be presented
/// then should be transitioned into a ViewPair
public struct Element<Identifier: Equatable>: ElementInterface {
    public let view: UIView
    public let usage: Identifier
    public let snapshot: UIImage?

    public init(view: UIView, use: Identifier, snapshot: UIImage? = nil) {
        self.view = view
        usage = use
        self.snapshot = snapshot
    }

    public func matchesUsage(other: ElementInterface) -> Bool {
        guard let other = other as? Element else { return false }
        let otherUsage = other.usage
        return otherUsage == usage
    }

    public func createPair(_ element: ElementInterface) -> ElementPair {
        return ElementPair(fromView: view, finalView: element.view, shouldScale: false, snapshot: snapshot ?? view.snapshot())
    }
}

public struct ElementPair {
    let fromView: UIView
    let finalView: UIView
    let shouldScale: Bool
    let snapshot: UIImage

    public init(fromView: UIView, finalView: UIView, shouldScale: Bool = true, snapshot: UIImage) {
        self.fromView = fromView
        self.finalView = finalView
        self.shouldScale = shouldScale
        self.snapshot = snapshot
    }
}

public struct SnapshottedElementPair {
    public let pair: ElementPair
    public let imageView: UIImageView

    public init(pair: ElementPair) {
        self.pair = pair
        imageView = UIImageView(image: pair.snapshot)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = pair.fromView.frameInSuperview
    }
}

extension Collection where Element == ElementPair {
    func hideOriginViews() {
        forEach { $0.fromView.alpha = 0 }
    }

    func showOriginViews() {
        forEach { $0.fromView.alpha = 1 }
    }

    func hasZeroFramedViews() -> Bool {
        return reduce(false) { (current, view) -> Bool in
            current || view.finalView.frame == CGRect.zero
        }
    }
}

extension Collection where Element == SnapshottedElementPair {
    func animateFrame(direction: AnimationDirection) {
        forEach {
            switch direction {
            case .forward:
                let imageScaleTransform = $0.pair.finalView.frameInSuperview
                    .scaleTransform(to: $0.pair.fromView.frameInSuperview)
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

    func animateOpacity(direction: AnimationDirection) {
        forEach {
            switch direction {
            case .forward:
                $0.imageView.alpha = 0
            case .backward:
                $0.imageView.alpha = 1
            }
        }
    }

    func removeSnapshotViews() {
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
    func zip<T>(_ otherArray: [Element], combiner: (Element, Element) -> T) -> [T] {
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
