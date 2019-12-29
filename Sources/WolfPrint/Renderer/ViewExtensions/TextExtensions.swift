import Foundation
import UIKit

extension Text: ViewBuildable {
    public func buildDebugTree(tree: inout ViewNode, parent: ViewNode) {
        var inheritedFont: Font = .body
        for ancestor in parent.ancestorsIncludingSelf {
            if let font = (ancestor.value as? ModifiedContentDrawable<_EnvironmentKeyWritingModifier<Font?>>)?.modifier.value {
                inheritedFont = font
                break
            }
        }
        let modifiers = [Modifier.font(inheritedFont)] + _modifiers
        switch _storage {
        case .verbatim(let content):
            parent.addChild(node: ViewNode(value: TextDrawable(text: content, modifiers: modifiers)))
        case .anyTextStorage(let content):
            parent.addChild(node: ViewNode(value: TextDrawable(text: content.storage, modifiers: modifiers)))
        }
    }
}

extension Font {
    var osFont: UIFont {
        switch provider {
        case let provider as CTFontProvider:
            return provider.font as UIFont
        case let provider as TextStyleProvider:
            var fontWeight = Font.Weight.regular
            for modifier in _modifiers {
                switch modifier {
                case .weight(let w):
                    fontWeight = w
                case .bold:
                    fontWeight = .bold
                }
            }

            let style = Self.uiFontStyle(for: provider.style)
            let metrics = UIFontMetrics(forTextStyle: style)
            let design = Self.uiFontDesign(for: provider.design)
            let desc = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style).withDesign(design)!
            let weight = Self.uiFontWeight(for: fontWeight)
            let font = UIFont.systemFont(ofSize: desc.pointSize, weight: weight)
            return metrics.scaledFont(for: font)
        case let provider as SystemProvider:
            var weight = provider.weight
            for modifier in _modifiers {
                switch modifier {
                case .weight(let w):
                    weight = w
                case .bold:
                    weight = .bold
                }
            }
            let font = UIFont.systemFont(ofSize: provider.size, weight: Self.uiFontWeight(for: weight))
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
        case .title:
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
        switch weight {
        case .ultraLight:
            return .ultraLight
        case .thin:
            return .thin
        case .light:
            return .light
        case .regular:
            return .regular
        case .medium:
            return .medium
        case .semibold:
            return .semibold
        case .bold:
            return .bold
        case .heavy:
            return .heavy
        case .black:
            return .black
        }
    }
}

extension UIFont {
    public func sizeForText(_ text: String, in size: CGSize) -> CGSize {
        let attributes: [NSAttributedString.Key: Any] = [.font: self]
        let bounds = (text as NSString).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return bounds.size
    }
}
