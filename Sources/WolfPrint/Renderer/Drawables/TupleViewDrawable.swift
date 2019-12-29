import CoreGraphics

struct TupleViewDrawable: Drawable {
    public var origin: CGPoint = .zero
    public var size: CGSize = .zero

    init() {

    }

    public func wantedWidthForProposal(_ proposedWidth: CGFloat, otherLength: CGFloat? = nil) -> CGFloat {
        return proposedWidth
    }

    public func wantedHeightForProposal(_ proposedHeight: CGFloat, otherLength: CGFloat? = nil) -> CGFloat {
        return proposedHeight
    }
}

extension TupleViewDrawable: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "TupleView [\(size)]"
    }
}
