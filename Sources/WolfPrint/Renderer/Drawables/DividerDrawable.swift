import CoreGraphics

public struct DividerDrawable: Drawable {
    public var origin: CGPoint = .zero
    public var size: CGSize = .zero

    public var axis: Axis

    public init(axis: Axis) {
        self.axis = axis
    }

    public func wantedWidthForProposal(_ proposedWidth: CGFloat, otherLength: CGFloat? = nil, node: ViewNode) -> CGFloat {
        if axis == .horizontal {
            return proposedWidth
        } else {
            return 1
        }
    }

    public func wantedHeightForProposal(_ proposedHeight: CGFloat, otherLength: CGFloat? = nil, node: ViewNode) -> CGFloat {
        if axis == .vertical {
            return proposedHeight
        } else {
            return 1
        }
    }
}

extension DividerDrawable: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "Divider [\(size), \(origin)]"
    }
}
