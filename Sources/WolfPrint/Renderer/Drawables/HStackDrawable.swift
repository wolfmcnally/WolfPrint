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

    public func wantedWidthForProposal(_ proposedWidth: CGFloat, otherLength: CGFloat? = nil) -> CGFloat {
        return proposedWidth
    }

    public func wantedHeightForProposal(_ proposedHeight: CGFloat, otherLength: CGFloat? = nil) -> CGFloat {
        return proposedHeight
    }
}

extension HStackDrawable: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "HStack [\(origin), \(size), \(alignment), \(String(describing: spacing))]"
    }
}
