import UIKit
import CoreGraphics

extension Image: ViewBuildable {
    public func buildDebugTree(tree: inout ViewNode, parent: ViewNode) {
        if let provider = provider as? UIImageProvider {
            let uiImage = provider.uiImage
            parent.addChild(node: ViewNode(value: ImageDrawable(uiImage: uiImage, interpolation: interpolation)))
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

extension Image.Interpolation {
    var cgInterpolationQuality: CGInterpolationQuality {
        switch self {
        case .high: return .high
        case .medium: return .medium
        case .low: return .low
        case .none: return .none
        }
    }
}
