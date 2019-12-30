import CoreGraphics

public protocol Drawable: CustomDebugStringConvertible {
    var origin: CGPoint { get set }
    var size: CGSize { get set }

    var rect: CGRect { get }

    func wantedWidthForProposal(_ proposedWidth: CGFloat, otherLength: CGFloat?, node: ViewNode) -> CGFloat
    func wantedHeightForProposal(_ proposedHeight: CGFloat, otherLength: CGFloat?, node: ViewNode) -> CGFloat
}

extension Drawable {
    public var rect: CGRect {
        CGRect(origin: origin, size: size)
    }
}
