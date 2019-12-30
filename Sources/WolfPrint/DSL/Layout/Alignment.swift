import Foundation
import CoreGraphics

public struct Alignment {
    public var horizontal: HorizontalAlignment
    public var vertical: VerticalAlignment

    public init(horizontal: HorizontalAlignment, vertical: VerticalAlignment) {
        self.horizontal = horizontal
        self.vertical = vertical
    }

    public static let center = Alignment(horizontal: .center, vertical: .center)
    public static let leading = Alignment(horizontal: .leading, vertical: .center)
    public static let trailing = Alignment(horizontal: .trailing, vertical: .center)
    public static let top = Alignment(horizontal: .center, vertical: .top)
    public static let bottom = Alignment(horizontal: .center, vertical: .bottom)
    public static let topLeading = Alignment(horizontal: .leading, vertical: .top)
    public static let topTrailing = Alignment(horizontal: .trailing, vertical: .top)
    public static let bottomLeading = Alignment(horizontal: .leading, vertical: .bottom)
    public static let bottomTrailing = Alignment(horizontal: .trailing, vertical: .bottom)
}

public protocol AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat
}

struct AlignmentKey: Hashable, Comparable {
    private let bits: UInt
    internal static func < (lhs: AlignmentKey, rhs: AlignmentKey) -> Bool {
        return lhs.bits < rhs.bits
    }
}

// FIXME: This is not the actual implementation. SwiftUI does not use enums. See below
public enum HorizontalAlignment {
    case leading
    case center
    case trailing
}

// FIXME: This is not the actual implementation. SwiftUI does not use enums. See below.
public enum VerticalAlignment {
    case top
    case center
    case bottom
    case firstTextBaseline
    case lastTextBaseline
}

/*
public struct HorizontalAlignment {
    internal let key: AlignmentKey
    public init(_ id: AlignmentID.Type) {
        fatalError()
    }

    public static func == (a: HorizontalAlignment, b: HorizontalAlignment) -> Bool {
        return a.key == b.key
    }
}
public struct VerticalAlignment {
    internal let key: AlignmentKey
    public init(_ id: AlignmentID.Type) {
        fatalError()
    }

    public static func == (a: VerticalAlignment, b: VerticalAlignment) -> Bool {
        return a.key == b.key
    }
}
extension VerticalAlignment {
    public static var top: VerticalAlignment {
        fatalError()
    }
    public static var center: VerticalAlignment {
        fatalError()
    }
    public static var bottom: VerticalAlignment {
        fatalError()
    }
    public static var firstTextBaseline: VerticalAlignment {
        fatalError()
    }
    public static var lastTextBaseline: VerticalAlignment {
        fatalError()
    }
}
extension VerticalAlignment: Equatable {
}
extension HorizontalAlignment {
    public static var leading: HorizontalAlignment {
        fatalError()
    }
    public static var center: HorizontalAlignment {
        fatalError()
    }
    public static var trailing: HorizontalAlignment {
        fatalError()
    }
}
extension HorizontalAlignment: Equatable {
}
*/
