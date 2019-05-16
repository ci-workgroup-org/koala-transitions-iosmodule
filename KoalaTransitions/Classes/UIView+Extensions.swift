

// MARK: - <#Description#>

import UIKit

extension UIView {
    /// returns the receiver's frame in it's superview coordinates, or it's frame
    public var frameInSuperview: CGRect {
        if let superview = superview {
            return superview.convert(frame, to: nil)
        }
        return frame
    }

    /// Convert a UIView into a UIImage.
    ///
    /// - Returns: An image represented the view.
    public func snapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0.0)

        defer { UIGraphicsEndImageContext() }

        guard let context = UIGraphicsGetCurrentContext() else {
            print("No context to render image.")
            return UIImage()
        }

        layer.render(in: context)

        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            print("Failed to render image from current context.")
            return UIImage()
        }

        return image
    }
}
