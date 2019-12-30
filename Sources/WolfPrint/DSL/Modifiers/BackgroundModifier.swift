import CoreGraphics

public struct BackgroundModifier<Background>: ViewModifier where Background: View {
    public typealias Body = Never
    public typealias Content = View

    public let background: Background
    public let alignment: Alignment

    init(background: Background, alignment: Alignment) {
        self.background = background
        self.alignment = alignment
    }

    public func wantedWidthForProposal(_ proposedWidth: CGFloat, otherLength: CGFloat?, node: ViewNode) -> CGFloat {
        let child = node.children.first!
        return child.value.wantedWidthForProposal(proposedWidth, otherLength: otherLength, node: child)
    }

    public func wantedHeightForProposal(_ proposedHeight: CGFloat, otherLength: CGFloat?, node: ViewNode) -> CGFloat {
        let child = node.children.first!
        return child.value.wantedHeightForProposal(proposedHeight, otherLength: otherLength, node: child)
    }
}

extension BackgroundModifier {
    public static func _makeView(modifier: _GraphValue<BackgroundModifier<Background>>, inputs: _ViewInputs, body: @escaping (_Graph, _ViewInputs) -> _ViewOutputs) -> _ViewOutputs {
        fatalError()
    }
}

extension View {
    public func background<Background>(_ background: Background, alignment: Alignment = .center) -> some View where Background: View {
        return modifier(
            BackgroundModifier(background: background, alignment: alignment))
    }
}
