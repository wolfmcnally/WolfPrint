extension HStack: ViewBuildable {
    public func buildDebugTree(tree: inout ViewNode, parent: ViewNode) {
        let node = ViewNode(value: HStackDrawable(alignment: _tree.root.alignment, spacing: _tree.root.spacing))
        parent.addChild(node: node)

        ViewExtractor.extractViews(contents: _tree.content).forEach {
            $0.buildDebugTree(tree: &tree, parent: node)
        }
    }
}
