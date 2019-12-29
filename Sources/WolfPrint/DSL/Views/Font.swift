import Foundation
import CoreGraphics
import CoreText

extension View {
    public func font(_ font: Font?) -> some View {
        return environment(\.font, font)
    }
}

enum FontEnvironmentKey: EnvironmentKey {
    static var defaultValue: Font? { return nil }
}

extension EnvironmentValues {
    public var font: Font? {
        set { self[FontEnvironmentKey.self] = newValue }
        get { self[FontEnvironmentKey.self] }
    }
}

public class AnyFontBox: Hashable, Equatable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self).hashValue)
    }

    public static func ==(lhs: AnyFontBox, rhs: AnyFontBox) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
}

public class CTFontProvider: AnyFontBox {
    public var font: CTFont

    init(_ font: CTFont) {
        self.font = font
    }

    public static func ==(lhs: CTFontProvider, rhs: CTFontProvider) -> Bool {
        return lhs.font == rhs.font
    }
}

public class SystemProvider: AnyFontBox {
    public var size: CGFloat
    public var weight: Font.Weight
    public var design: Font.Design

    init(size: CGFloat, weight: Font.Weight, design: Font.Design) {
        self.size = size
        self.weight = weight
        self.design = design
    }

    public static func ==(lhs: SystemProvider, rhs: SystemProvider) -> Bool {
        return lhs.size == rhs.size && lhs.weight == rhs.weight && lhs.design == rhs.design
    }
}

public class TextStyleProvider: AnyFontBox {
    public var style: Font.TextStyle
    public var design: Font.Design

    init(style: Font.TextStyle, design: Font.Design) {
        self.style = style
        self.design = design
    }

    public static func ==(lhs: TextStyleProvider, rhs: TextStyleProvider) -> Bool {
        return lhs.style == rhs.style && lhs.design == rhs.design
    }
}

public class NamedFontProvider: AnyFontBox {
    public var name: String
    public var size: CGFloat

    init(name: String, size: CGFloat) {
        self.name = name
        self.size = size
    }

    public static func ==(lhs: NamedFontProvider, rhs: NamedFontProvider) -> Bool {
        return lhs.name == rhs.name && lhs.size == rhs.size
    }
}

public struct Font: Hashable {
    public var provider: AnyFontBox

    public init(_ font: CTFont) {
        provider = CTFontProvider(font)
    }

    init(provider: AnyFontBox) {
        self.provider = provider
    }

    public static func system(_ style: Font.TextStyle, design: Font.Design = .default) -> Font {
        Font(provider: TextStyleProvider(style: style, design: design))
    }

    public static func system(size: CGFloat, weight: Font.Weight = .regular, design: Font.Design = .default) -> Font {
        Font(provider: SystemProvider(size: size, weight: weight, design: design))
    }

    public static func custom(_ name: String, size: CGFloat) -> Font {
        Font(provider: NamedFontProvider(name: name, size: size))
    }

    public static func == (lhs: Font, rhs: Font) -> Bool {
        return lhs.provider == rhs.provider
    }
}

extension Font {
    public struct Weight: Hashable {
        public var value: CGFloat

        public static let ultraLight: Font.Weight = Weight(value: 100)
        public static let thin: Font.Weight = Weight(value: 200)
        public static let light: Font.Weight = Weight(value: 300)
        public static let regular: Font.Weight = Weight(value: 400)
        public static let medium: Font.Weight = Weight(value: 500)
        public static let semibold: Font.Weight = Weight(value: 600)
        public static let bold: Font.Weight = Weight(value: 700)
        public static let heavy: Font.Weight = Weight(value: 800)
        public static let black: Font.Weight = Weight(value: 900)
    }
}

extension Font {
    public static let largeTitle = Font.system(Font.TextStyle.largeTitle)
    public static let title1 = Font.system(Font.TextStyle.title1)
    public static let title2 = Font.system(Font.TextStyle.title2)
    public static let title3 = Font.system(Font.TextStyle.title3)
    public static var headline = Font.system(Font.TextStyle.headline)
    public static var subheadline = Font.system(Font.TextStyle.subheadline)
    public static var body = Font.system(Font.TextStyle.body)
    public static var callout = Font.system(Font.TextStyle.callout)
    public static var footnote = Font.system(Font.TextStyle.footnote)
    public static var caption1 = Font.system(Font.TextStyle.caption1)
    public static var caption2 = Font.system(Font.TextStyle.caption2)

    public enum TextStyle: CaseIterable {
        case largeTitle
        case title1
        case title2
        case title3
        case headline
        case subheadline
        case body
        case callout
        case footnote
        case caption1
        case caption2
    }

    public enum Design: Hashable {
        case `default`
        case serif
        case rounded
        case monospaced
    }
}
