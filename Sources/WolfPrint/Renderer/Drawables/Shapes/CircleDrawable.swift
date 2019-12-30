import CoreGraphics

public struct CircleDrawable: Drawable {
    public var origin: CGPoint = .zero
    public var size: CGSize = .zero

    public init() {
    }

    public func wantedWidthForProposal(_ proposedWidth: CGFloat, otherLength: CGFloat? = nil, node: ViewNode) -> CGFloat {
        return proposedWidth
    }

    public func wantedHeightForProposal(_ proposedHeight: CGFloat, otherLength: CGFloat? = nil, node: ViewNode) -> CGFloat {
        return proposedHeight
    }
}

extension CircleDrawable: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "Circle [\(size)]"
    }
}
