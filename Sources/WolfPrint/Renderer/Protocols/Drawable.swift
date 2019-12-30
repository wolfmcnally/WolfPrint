import CoreGraphics

public protocol Drawable: CustomDebugStringConvertible {
    var origin: CGPoint { get set }
    var size: CGSize { get set }

    func wantedWidthForProposal(_ proposedWidth: CGFloat, otherLength: CGFloat?, node: ViewNode) -> CGFloat
    func wantedHeightForProposal(_ proposedHeight: CGFloat, otherLength: CGFloat?, node: ViewNode) -> CGFloat

    var passthrough: Bool { get }
}

extension Drawable {
    public var passthrough: Bool {
        return false
    }
}
