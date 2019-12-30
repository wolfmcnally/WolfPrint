import CoreGraphics

public struct ColorDrawable: Drawable {
    public var origin: CGPoint = .zero
    public var size: CGSize = .zero

    let color: Color

    public init(color: Color) {
        self.color = color
    }

    public func wantedWidthForProposal(_ proposedWidth: CGFloat, otherLength: CGFloat? = nil, node: ViewNode) -> CGFloat {
        return proposedWidth
    }

    public func wantedHeightForProposal(_ proposedHeight: CGFloat, otherLength: CGFloat? = nil, node: ViewNode) -> CGFloat {
        return proposedHeight
    }
}

extension ColorDrawable: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "Color [\(size)] {color: \(color)}"
    }
}
