import WolfFoundation

extension TupleView: ViewBuildable {
    public func buildDebugTree(tree: inout ViewNode, parent: ViewNode) {
//        print("parent: \(parent)")
//        print("value: \(content)")

        for child in Mirror(reflecting: content).children {
            if let viewBuildable = child.value as? ViewBuildable {
                viewBuildable.buildDebugTree(tree: &tree, parent: parent)
            } else {
                guard let optionalValue = child.value as? OptionalProtocol else {
                    print("Can't render custom views yet.")
                    continue
                }
                guard optionalValue.isSome else {
                    // This is conditional content that wasn't included
                    continue
                }
                let a = unwrap(optionalValue)
                guard let viewBuildable = a as? ViewBuildable else {
                    print("We can't add whatever it is to the tree: \(a)")
                    continue
                }
                viewBuildable.buildDebugTree(tree: &tree, parent: parent)
            }
        }
    }
}
