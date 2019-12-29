import CoreGraphics

struct HStackDrawable: Drawable {
    public var origin: CGPoint = .zero
    public var size: CGSize = .zero

    public var alignment: VerticalAlignment

    init(alignment: VerticalAlignment) {
        self.alignment = alignment
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
        return "HStack [\(origin), \(size)]"
    }
}
