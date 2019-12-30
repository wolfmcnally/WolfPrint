import CoreGraphics

struct HStackDrawable: Drawable {
    public var origin: CGPoint = .zero
    public var size: CGSize = .zero

    public let alignment: VerticalAlignment
    public let spacing: CGFloat?

    init(alignment: VerticalAlignment, spacing: CGFloat?) {
        self.alignment = alignment
        self.spacing = spacing
    }

    public func wantedWidthForProposal(_ proposedWidth: CGFloat, otherLength: CGFloat? = nil, node: ViewNode) -> CGFloat {
        node.calculateChildSizes(givenWidth: proposedWidth, givenHeight: otherLength!)
        return node.value.size.width
//        return proposedWidth
    }

    public func wantedHeightForProposal(_ proposedHeight: CGFloat, otherLength: CGFloat? = nil, node: ViewNode) -> CGFloat {
        return proposedHeight
    }
}

extension HStackDrawable: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "HStack [\(origin), \(size), \(alignment), \(String(describing: spacing))]"
    }
}
