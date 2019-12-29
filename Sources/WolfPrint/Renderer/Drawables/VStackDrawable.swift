import CoreGraphics

struct VStackDrawable: Drawable {
    public var origin: CGPoint = .zero
    public var size: CGSize = .zero

    public var alignment: HorizontalAlignment

    init(alignment: HorizontalAlignment) {
        self.alignment = alignment
    }

    public func wantedWidthForProposal(_ proposedWidth: CGFloat, otherLength: CGFloat? = nil) -> CGFloat {
        return proposedWidth
    }

    public func wantedHeightForProposal(_ proposedHeight: CGFloat, otherLength: CGFloat? = nil) -> CGFloat {
        return proposedHeight
    }
}

extension VStackDrawable: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "VStack [\(origin), \(size)]"
    }
}
