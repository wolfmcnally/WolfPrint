import CoreGraphics

public struct ModifiedContentDrawable<Modifier>: Drawable where Modifier : ViewModifier {
    public var origin: CGPoint = .zero

    private var _size: CGSize = .zero
    public var size: CGSize {
        get { return _size }
        set {
            if _size == .zero {
                _size = newValue
            }
        }
    }
//    public var size: CGSize = .zero

    let modifier: Modifier

    public init(modifier: Modifier) {
        self.modifier = modifier
    }

    public func wantedWidthForProposal(_ proposedWidth: CGFloat, otherLength: CGFloat? = nil, node: ViewNode) -> CGFloat {
        modifier.wantedWidthForProposal(proposedWidth, otherLength: otherLength, node: node)
    }

    public func wantedHeightForProposal(_ proposedHeight: CGFloat, otherLength: CGFloat? = nil, node: ViewNode) -> CGFloat {
        modifier.wantedHeightForProposal(proposedHeight, otherLength: otherLength, node: node)
//        return proposedHeight
    }
}


extension ModifiedContentDrawable: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "ModifiedContent [\(origin), \(size)] {\(modifier)}"
    }
}
