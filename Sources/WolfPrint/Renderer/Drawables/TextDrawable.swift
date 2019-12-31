import Foundation
import CoreGraphics
import UIKit

public struct TextDrawable: Drawable {
    public var origin: CGPoint = .zero

    private var _size: CGSize = .zero
    public var size: CGSize {
        get { return _size }
        set {
            if _size == .zero {
                _size = newValue
            }
        }
    }
//    public var size: CGSize = .zero

    public let text: String
    public let modifiers: [Text.Modifier]

    public var resolvedFont: Font {
        var result: Font!
        for modifier in modifiers {
            switch modifier {
            case .font(let font):
                result = font
            case .bold:
                result = Font(result.osFont.applyBold)
            case .italic:
                result = Font(result.osFont.applyItalic)
            case .fontWeight(let weight):
                guard let weight = weight else { continue }
                let uiFontWeight = Font.uiFontWeight(for: weight)
                result = Font(result.osFont.applyWeight(uiFontWeight))
            default:
                continue
            }
        }
        return result!
    }

    public init(text: String, modifiers: [Text.Modifier]) {
        self.text = text
        self.modifiers = modifiers
    }

    public func wantedWidthForProposal(_ proposedWidth: CGFloat, otherLength: CGFloat? = nil, node: ViewNode) -> CGFloat {
        let height = size.height > 0 ? size.height : otherLength ?? CGFloat.greatestFiniteMagnitude
        return resolvedFont.osFont.sizeForText(text, in: CGSize(width: proposedWidth, height: height)).width
    }

    public func wantedHeightForProposal(_ proposedHeight: CGFloat, otherLength: CGFloat? = nil, node: ViewNode) -> CGFloat {
        let width = size.width > 0 ? size.width : otherLength ?? CGFloat.greatestFiniteMagnitude
        return resolvedFont.osFont.sizeForText(text, in: CGSize(width: width, height: proposedHeight)).height
    }
}

extension TextDrawable: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "Text [\(origin), \(size)] {text: \(text), font: \(resolvedFont)}"
    }
}
