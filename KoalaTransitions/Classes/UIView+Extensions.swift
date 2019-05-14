

extension UIView {
    public func frameInSuperView() -> CGRect {
        if let superview = superview {
            return superview.convert(frame, to: nil)
        }
        print("[ANIMATION WARNING] Seems like this view is not in views hierarchy\n\(self)\nOriginal frame returned")
        return frame
    }

    /// Convert a UIView into a UIImage.
    ///
    /// - Returns: An image represented the view.
    public func snapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0.0)

        defer { UIGraphicsEndImageContext() }

        guard let context = UIGraphicsGetCurrentContext() else {
            debugPrint("No context to render image.")
            return UIImage()
        }

        layer.render(in: context)

        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            debugPrint("Failed to render image from current context.")
            return UIImage()
        }

        return image
    }
}
