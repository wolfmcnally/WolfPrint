import CoreGraphics

public protocol ViewModifier {
    associatedtype Body: View
    typealias Content = _ViewModifier_Content<Self>
    func body(content: Self.Content) -> Self.Body
    func wantedWidthForProposal(_ proposedWidth: CGFloat, otherLength: CGFloat?, node: ViewNode) -> CGFloat
    func wantedHeightForProposal(_ proposedHeight: CGFloat, otherLength: CGFloat?, node: ViewNode) -> CGFloat
}

extension ViewModifier where Self.Body == Never {
    public func body(content: Self.Content) -> Self.Body {
        fatalError()
    }
}

extension ViewModifier {
    public func wantedWidthForProposal(_ proposedWidth: CGFloat, otherLength: CGFloat?, node: ViewNode) -> CGFloat {
        let child = node.children.first!
        return child.value.wantedWidthForProposal(proposedWidth, otherLength: otherLength, node: child)
    }

    public func wantedHeightForProposal(_ proposedHeight: CGFloat, otherLength: CGFloat?, node: ViewNode) -> CGFloat {
        let child = node.children.first!
        return child.value.wantedHeightForProposal(proposedHeight, otherLength: otherLength, node: child)
    }
}

extension ViewModifier {
    public func concat<T>(_ modifier: T) -> ModifiedContent<Self, T> {
        return .init(content: self, modifier: modifier)
    }
}

extension ViewModifier {
    static func _makeView(modifier: _GraphValue<Self>, inputs: _ViewInputs, body: @escaping (_Graph, _ViewInputs) -> _ViewOutputs) -> _ViewOutputs {
        fatalError()
    }
    static func _makeViewList(modifier: _GraphValue<Self>, inputs: _ViewListInputs, body: @escaping (_Graph, _ViewListInputs) -> _ViewListOutputs) -> _ViewListOutputs {
        fatalError()
    }
}
