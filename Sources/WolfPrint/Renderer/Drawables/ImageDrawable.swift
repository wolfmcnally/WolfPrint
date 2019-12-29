import UIKit
import CoreGraphics

public struct ImageDrawable: Drawable {
    public var origin: CGPoint = .zero
    public var size: CGSize = .zero

    public var uiImage: UIImage

    public init(uiImage: UIImage) {
        self.uiImage = uiImage
    }

    public func wantedWidthForProposal(_ proposedWidth: CGFloat, otherLength: CGFloat? = nil) -> CGFloat {
        return uiImage.size.width
    }

    public func wantedHeightForProposal(_ proposedHeight: CGFloat, otherLength: CGFloat? = nil) -> CGFloat {
        return uiImage.size.height
    }
}

extension ImageDrawable: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "Image [\(origin), \(size)]"
    }
}
