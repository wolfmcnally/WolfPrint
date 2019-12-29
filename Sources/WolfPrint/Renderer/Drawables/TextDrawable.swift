import Foundation
import CoreGraphics

public struct TextDrawable: Drawable {
    public var origin: CGPoint = .zero
    public var size: CGSize = .zero

    public let text: String
    public let modifiers: [Text.Modifier]

    public var resolvedFont: Font {
        var result: Font?
        for modifier in modifiers {
            switch modifier {
            case .font(let font):
                result = font
            default:
                continue
            }
        }

        return result ?? Font.body
    }

    public init(text: String, modifiers: [Text.Modifier]) {
        self.text = text
        self.modifiers = modifiers
    }

    public func wantedWidthForProposal(_ proposedWidth: CGFloat, otherLength: CGFloat? = nil) -> CGFloat {
        let height = size.height > 0 ? size.height : otherLength ?? CGFloat.greatestFiniteMagnitude
        return resolvedFont.font.sizeForText(text, in: CGSize(width: proposedWidth, height: height)).width
    }

    public func wantedHeightForProposal(_ proposedHeight: CGFloat, otherLength: CGFloat? = nil) -> CGFloat {
        let width = size.width > 0 ? size.width : otherLength ?? CGFloat.greatestFiniteMagnitude
        return resolvedFont.font.sizeForText(text, in: CGSize(width: width, height: proposedHeight)).height
    }
}

extension TextDrawable: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "Text [\(origin), \(size)] {text: \(text), font: \(resolvedFont)}"
    }
}
