import Foundation
import CoreGraphics

public struct PaddingModifier: ViewModifier {
    static let defaultPadding: CGFloat = 20

    public typealias Body = Never
    public typealias Content = View

    public var value: EdgeInsets

    init(_ insets: EdgeInsets) {
        self.value = insets
    }

    init(_ edges: Edge.Set = .all, _ length: CGFloat? = nil) {
        let computedLength = length ?? Self.defaultPadding
        self.value = EdgeInsets(top: edges.contains(.top) ? computedLength : 0,
                                leading: edges.contains(.leading) ? computedLength : 0,
                                bottom: edges.contains(.bottom) ? computedLength : 0,
                                trailing: edges.contains(.trailing) ? computedLength : 0)
    }

    init(_ length: CGFloat) {
        self.value = EdgeInsets(top: length, leading: length, bottom: length, trailing: length)
    }

    public func wantedWidthForProposal(_ proposedWidth: CGFloat, otherLength: CGFloat?, node: ViewNode) -> CGFloat {
        let child = node.children.first!
        let widthLessPadding = proposedWidth - value.horizontal
        let otherLengthLessPadding: CGFloat?
        if let otherLength = otherLength {
            otherLengthLessPadding = otherLength - value.vertical
        } else {
            otherLengthLessPadding = nil
        }
        let childWantedWidth = child.value.wantedWidthForProposal(widthLessPadding, otherLength: otherLengthLessPadding, node: child)
        return childWantedWidth + value.horizontal
    }

    public func wantedHeightForProposal(_ proposedHeight: CGFloat, otherLength: CGFloat?, node: ViewNode) -> CGFloat {
        let child = node.children.first!
        let heightLessPadding = proposedHeight - value.vertical
        let otherLengthLessPadding: CGFloat?
        if let otherLength = otherLength {
            otherLengthLessPadding = otherLength - value.horizontal
        } else {
            otherLengthLessPadding = nil
        }
        let childWantedHeight = child.value.wantedHeightForProposal(heightLessPadding, otherLength: otherLengthLessPadding, node: child)
        return childWantedHeight + value.vertical
    }
}

extension PaddingModifier: CustomStringConvertible {
    public var description: String {
        return "PaddingModifier {padding: \(value)}"
    }
}

extension View {
    public func padding(_ insets: EdgeInsets) -> some View {
        return modifier(PaddingModifier(insets))
    }

    public func padding(_ edges: Edge.Set = .all, _ length: CGFloat? = nil) -> some View {
        return modifier(PaddingModifier(edges, length))
    }

    public func padding(_ length: CGFloat) -> some View {
        return modifier(PaddingModifier(length))
    }
}
