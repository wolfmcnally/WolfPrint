import CoreGraphics

struct VStackDrawable: Drawable {
    public var origin: CGPoint = .zero
    public var size: CGSize = .zero

    public let alignment: HorizontalAlignment
    public let spacing: CGFloat?

    init(alignment: HorizontalAlignment, spacing: CGFloat?) {
        self.alignment = alignment
        self.spacing = spacing
    }

    public func wantedWidthForProposal(_ proposedWidth: CGFloat, otherLength: CGFloat? = nil, node: ViewNode) -> CGFloat {
        return proposedWidth
    }

    public func wantedHeightForProposal(_ proposedHeight: CGFloat, otherLength: CGFloat? = nil, node: ViewNode) -> CGFloat {
        return proposedHeight
    }
}

extension VStackDrawable: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "VStack [\(origin), \(size), \(alignment), \(String(describing: spacing))]"
    }
}
