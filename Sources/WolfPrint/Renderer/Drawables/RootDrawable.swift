import CoreGraphics

public struct RootDrawable: Drawable {
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

extension RootDrawable: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "Root [\(size)]"
    }
}
