import Foundation

public class AnyTextStorage<Storage: StringProtocol> {
    public var storage: Storage

    internal init(storage: Storage) {
        self.storage = storage
    }
}

public class AnyTextModifier {
    init() {
    }
}

public struct Text: View, Equatable {
    public typealias Body = Never
    public var _storage: Storage
    public var _modifiers: [Text.Modifier] = [Modifier]()

    public enum Storage: Equatable {
        public static func == (lhs: Text.Storage, rhs: Text.Storage) -> Bool {
            switch (lhs, rhs) {
            case (.verbatim(let contentA), .verbatim(let contentB)):
                return contentA == contentB
            case (.anyTextStorage(let contentA), .anyTextStorage(let contentB)):
                return contentA.storage == contentB.storage
            default:
                return false
            }
        }

        case verbatim(String)
        case anyTextStorage(AnyTextStorage<String>)
    }

    public enum Modifier: Equatable {
        case foregroundColor(Color?)
        case font(Font?)
        case fontWeight(Font.Weight?)
        case bold
        case italic
        // case strikethrough((Bool, Color?))
        // case underline((Bool, Color?))
        // case kerning(CGFloat)
        // case baselineOffset(CGFloat)
        // case tracking(CGFloat)
        // case baselineOffset(CGFloat)

        public static func == (lhs: Text.Modifier, rhs: Text.Modifier) -> Bool {
            switch (lhs, rhs) {
            case (.foregroundColor(let colorA), .foregroundColor(let colorB)):
                return colorA == colorB
            case (.font(let fontA), .font(let fontB)):
                return fontA == fontB
            case (.bold, .bold):
                return true
            case (.italic, .italic):
                return true
            case (.fontWeight(let weightA), .fontWeight(let weightB)):
                return weightA == weightB
            default:
                return false
            }
        }
    }

    public init(verbatim content: String) {
        self._storage = .verbatim(content)
    }

    public init<S>(_ content: S) where S: StringProtocol {
        self._storage = .anyTextStorage(AnyTextStorage<String>(storage: String(content)))
    }

    public init(_ key: LocalizedStringKey, tableName: String? = nil, bundle: Bundle? = nil, comment: StaticString? = nil) {
        self._storage = .anyTextStorage(AnyTextStorage<String>(storage: key.key))
    }

    private init(verbatim content: String, modifiers: [Modifier] = []) {
        self._storage = .verbatim(content)
        self._modifiers = modifiers
    }

    public static func == (lhs: Text, rhs: Text) -> Bool {
        return lhs._storage == rhs._storage && lhs._modifiers == rhs._modifiers
    }
}

extension Text {
    public func foregroundColor(_ color: Color?) -> Text {
        textWithModifier(.foregroundColor(color))
    }

    public func font(_ font: Font?) -> Text {
        textWithModifier(.font(font))
    }

    public func bold() -> Text {
        textWithModifier(.bold)
    }

    public func italic() -> Text {
        textWithModifier(.italic)
    }

    public func fontWeight(_ weight: Font.Weight?) -> Text {
        textWithModifier(.fontWeight(weight))
    }

    private func textWithModifier(_ modifier: Modifier) -> Text {
        let modifiers = _modifiers + [modifier]
        switch _storage {
        case .verbatim(let content):
            return Text(verbatim: content, modifiers: modifiers)
        case .anyTextStorage(let content):
            return Text(verbatim: content.storage, modifiers: modifiers)
        }
    }
}

extension Text {
    public var body: Never {
        fatalError()
    }
}

extension Text {
    public static func _makeView(view: _GraphValue<Text>, inputs: _ViewInputs) -> _ViewOutputs {
        fatalError()
    }
}
