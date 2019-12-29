import CoreGraphics

struct ZStackDrawable: Drawable {
    public var origin: CGPoint = .zero
    public var size: CGSize = .zero

    public let alignment: Alignment

    init(alignment: Alignment) {
        self.alignment = alignment
    }

    public func wantedWidthForProposal(_ proposedWidth: CGFloat, otherLength: CGFloat? = nil) -> CGFloat {
        return proposedWidth
    }

    public func wantedHeightForProposal(_ proposedHeight: CGFloat, otherLength: CGFloat? = nil) -> CGFloat {
        return proposedHeight
    }
}

extension ZStackDrawable: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "ZStack [\(origin), \(size)]"
    }
}
