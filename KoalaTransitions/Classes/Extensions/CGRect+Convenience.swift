//
//  CGRect+Convenience.swift
//  KoalaTransitions
//
//  Created by Nicholas Trienens on 5/21/19.
//

import CoreGraphics
import Foundation

extension CGRect {
    /// scale Transform from the receiver to the incoming rect
    public func scaleTransform(to: CGRect) -> CGAffineTransform {
        let xScaleFactor = width / to.width
        let yScaleFactor = height / to.height
        return CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
    }

    /// midpoint of the reciever
    public var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }

    /// convert the reciever into a square, cropping the bottom or right
    public func squared() -> CGRect {
        return CGRect(x: origin.x, y: origin.y, width: max(size.width, size.height), height: max(size.width, size.height))
    }
}
