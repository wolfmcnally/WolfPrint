import UIKit
import CoreGraphics

public struct ImageDrawable: Drawable {
    public var origin: CGPoint = .zero
    public var size: CGSize = .zero

    public var uiImage: UIImage
    public var interpolation: Image.Interpolation?

    public init(uiImage: UIImage, interpolation: Image.Interpolation?) {
        self.uiImage = uiImage
        self.interpolation = interpolation
    }

    public func wantedWidthForProposal(_ proposedWidth: CGFloat, otherLength: CGFloat? = nil, node: ViewNode) -> CGFloat {
        return uiImage.size.width
    }

    public func wantedHeightForProposal(_ proposedHeight: CGFloat, otherLength: CGFloat? = nil, node: ViewNode) -> CGFloat {
        return uiImage.size.height
    }
}

extension ImageDrawable: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "Image [\(origin), \(size), interpolation: \(String(describing: interpolation))]"
    }
}
