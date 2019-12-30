import CoreGraphics

public struct SpacerDrawable: Drawable {
    public var origin: CGPoint = .zero
    public var size: CGSize = .zero

    public init() {
    }

    public func wantedWidthForProposal(_ proposedWidth: CGFloat, otherLength: CGFloat? = nil, node: ViewNode) -> CGFloat {
        if node.parent?.value is VStackDrawable {
            return 0
        } else {
            return proposedWidth
        }
    }

    public func wantedHeightForProposal(_ proposedHeight: CGFloat, otherLength: CGFloat? = nil, node: ViewNode) -> CGFloat {
        if node.parent?.value is HStackDrawable {
            return 0
        } else {
            return proposedHeight
        }
    }
}

extension SpacerDrawable: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "Spacer [\(size)]"
    }
}
