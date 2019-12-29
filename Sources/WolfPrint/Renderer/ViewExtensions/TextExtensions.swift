import Foundation
import UIKit

extension Text: ViewBuildable {
    public func buildDebugTree(tree: inout ViewNode, parent: ViewNode) {
        switch _storage {
        case .verbatim(let content):
            parent.addChild(node: ViewNode(value: TextDrawable(text: content, modifiers: _modifiers)))
        case .anyTextStorage(let content):
            parent.addChild(node: ViewNode(value: TextDrawable(text: content.storage, modifiers: _modifiers)))
        }
    }
}

extension Font {
    var font: UIFont {
        switch provider {
        case let provider as CTFontProvider:
            return provider.font
        case let provider as TextStyleProvider:
            let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: Self.uiFontStyle(for: provider.style)).withDesign(Self.uiFontDesign(for: provider.design))!
            return UIFont(descriptor: descriptor, size: 0)
        case let provider as SystemProvider:
            let font = UIFont.systemFont(ofSize: provider.size, weight: Self.uiFontWeight(for: provider.weight))
            let descriptor = font.fontDescriptor.withDesign(Self.uiFontDesign(for: provider.design))!
            return UIFont(descriptor: descriptor, size: 0)
        case let provider as NamedFontProvider:
            let descriptor = UIFontDescriptor(name: provider.name, size: provider.size)
            return UIFont(descriptor: descriptor, size: 0)
        default:
            fatalError()
        }
    }

    private static func uiFontStyle(for style: Font.TextStyle) -> UIFont.TextStyle {
        switch style {
        case .body:
            return .body
        case .callout:
            return .callout
        case .caption1:
            return .caption1
        case .caption2:
            return .caption2
        case .footnote:
            return .footnote
        case .headline:
            return .headline
        case .largeTitle:
            return .largeTitle
        case .subheadline:
            return .subheadline
        case .title1:
            return .title1
        case .title2:
            return .title2
        case .title3:
            return .title3
        }
    }

    private static func uiFontDesign(for design: Font.Design) -> UIFontDescriptor.SystemDesign {
        switch design {
        case .default:
            return .default
        case .serif:
            return .serif
        case .rounded:
            return .rounded
        case .monospaced:
            return .monospaced
        }
    }

    private static func uiFontWeight(for weight: Font.Weight) -> UIFont.Weight {
        UIFont.Weight(weight.value)
    }
}

extension UIFont {
    public func sizeForText(_ text: String, in size: CGSize) -> CGSize {
        let attributes: [NSAttributedString.Key: Any] = [.font: self]
        let bounds = (text as NSString).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return bounds.size
    }
}
