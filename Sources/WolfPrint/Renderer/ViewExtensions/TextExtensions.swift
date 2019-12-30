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
        let providedFont: UIFont

        switch provider {
        case let provider as CTFontProvider:
            providedFont = provider.font as UIFont
        case let provider as TextStyleProvider:
            let style = Self.uiFontStyle(for: provider.style)
            let design = Self.uiFontDesign(for: provider.design)
            let desc = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style).withDesign(design)!
            providedFont = UIFont(descriptor: desc, size: 0)
        case let provider as SystemProvider:
            let weight = Self.uiFontWeight(for: provider.weight)
            let size = provider.size
            let design = Self.uiFontDesign(for: provider.design)
            let font = UIFont.systemFont(ofSize: size, weight: weight)
            let descriptor = font.fontDescriptor.withDesign(design)!
            providedFont = UIFont(descriptor: descriptor, size: 0)
        case let provider as NamedFontProvider:
            let descriptor = UIFontDescriptor(name: provider.name, size: provider.size)
            return UIFont(descriptor: descriptor, size: 0)
        default:
            fatalError()
        }

        return _modifiers.reduce(providedFont) { font, modifier in
            switch modifier {
            case .weight(let weight):
                return font.applyWeight(Self.uiFontWeight(for: weight))
            case .bold:
                return font.applyBold
            case .italic:
                return font.applyItalic
            }
        }
    }

    static func uiFontStyle(for style: Font.TextStyle) -> UIFont.TextStyle {
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

    static func uiFontDesign(for design: Font.Design) -> UIFontDescriptor.SystemDesign {
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

    static func uiFontWeight(for weight: Font.Weight) -> UIFont.Weight {
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

extension UIFont {
    var applyBold: UIFont {
        let descriptor = fontDescriptor
        var traits = descriptor.symbolicTraits
        traits.insert(.traitBold)
        guard let newDescriptor = descriptor.withSymbolicTraits(traits) else { return self }
        return UIFont(descriptor: newDescriptor, size: 0)
    }

    var applyItalic: UIFont {
        let descriptor = fontDescriptor
        var traits = descriptor.symbolicTraits
        traits.insert(.traitItalic)
        guard let newDescriptor = descriptor.withSymbolicTraits(traits) else { return self }
        return UIFont(descriptor: newDescriptor, size: 0)
    }

    var isItalic: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitItalic)
    }

    func applyWeight(_ weight: UIFont.Weight) -> UIFont {
        let descriptor = fontDescriptor
        var traits = (descriptor.fontAttributes[.traits] as? [UIFontDescriptor.TraitKey: Any]) ?? [:]
        traits[.weight] = weight.rawValue as NSNumber
        let newDescriptor = descriptor.addingAttributes([.traits: traits])
        let weightedFont = UIFont(descriptor: newDescriptor, size: 0)
        let resultFont: UIFont
        if isItalic {
            resultFont = weightedFont.applyItalic
        } else {
            resultFont = weightedFont
        }
        return resultFont
    }
}
