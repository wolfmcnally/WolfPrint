import CoreGraphics

public struct ModifiedContentDrawable<Modifier>: Drawable {
    public var origin: CGPoint = .zero
    public var size: CGSize = .zero

    let modifier: Modifier

    public init(modifier: Modifier) {
        self.modifier = modifier
    }

    public func wantedWidthForProposal(_ proposedWidth: CGFloat, otherLength: CGFloat? = nil) -> CGFloat {
        return proposedWidth
    }

    public func wantedHeightForProposal(_ proposedHeight: CGFloat, otherLength: CGFloat? = nil) -> CGFloat {
        return proposedHeight
    }
}

extension ModifiedContentDrawable {
    public var passthrough: Bool {
        return true
    }
}


extension ModifiedContentDrawable: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "ModifiedContent [\(origin), \(size)] {\(modifier)}"
    }
}
