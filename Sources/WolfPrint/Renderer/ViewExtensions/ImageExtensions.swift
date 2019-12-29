import UIKit

extension Image: ViewBuildable {
    public func buildDebugTree(tree: inout ViewNode, parent: ViewNode) {
        if let provider = _provider as? UIImageProvider {
            let uiImage = provider.uiImage
            parent.addChild(node: ViewNode(value: ImageDrawable(uiImage: uiImage)))
        } else {
            print("Unknown Image")
        }
    }
}

public class UIImageProvider: AnyImageProviderBox {
    public var uiImage: UIImage

    init(uiImage: UIImage) {
        self.uiImage = uiImage
        super.init()
    }
}

extension Image {
    public init(uiImage: UIImage) {
        self = Image(provider: UIImageProvider(uiImage: uiImage))
    }
}
