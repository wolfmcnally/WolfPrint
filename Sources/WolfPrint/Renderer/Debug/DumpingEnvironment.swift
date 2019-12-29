import CoreGraphics

/// Credits: Chris Eidhof / objc.io
/// https://www.objc.io/blog/2019/10/29/swiftui-environment/
public struct DumpingEnvironment<V: View>: View {
    @Environment(\.self) var env
    public let content: V
    public var body: some View {
        dump(env)
        return content
    }

    public init(content: V) {
        self.content = content
    }
}

extension DumpingEnvironment {
    public func buildDebugTree(tree: inout ViewNode, parent: ViewNode) {
        let node = ViewNode(value: DumpingEnvironmentDrawable())
        parent.addChild(node: node)

        if let element = content as? ViewBuildable {
            element.buildDebugTree(tree: &tree, parent: node)
        }
    }
}

public struct DumpingEnvironmentDrawable: Drawable {
    public var origin: CGPoint = .zero
    public var size: CGSize = .zero

    public func wantedWidthForProposal(_ proposedWidth: CGFloat, otherLength: CGFloat? = nil) -> CGFloat {
        return proposedWidth
    }

    public func wantedHeightForProposal(_ proposedHeight: CGFloat, otherLength: CGFloat? = nil) -> CGFloat {
        return proposedHeight
    }

    public var debugDescription: String {
        return "DumpingEnvironment"
    }
}
