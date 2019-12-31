import Foundation

public struct Image: Equatable {
    public var provider: AnyImageProviderBox
    public var interpolation: Interpolation?

    init(provider: AnyImageProviderBox, interpolation: Interpolation? = nil) {
        self.provider = provider
        self.interpolation = interpolation
    }

    public static func == (lhs: Image, rhs: Image) -> Bool {
        return ObjectIdentifier(lhs.provider) == ObjectIdentifier(rhs.provider)
    }
}

extension Image {
    public typealias Body = Never
}

open class AnyImageProviderBox {
    public init() {
    }
}

extension Image: View {
    public var body: Never {
        fatalError()
    }
}

extension Image {
    public init(_ name: String, bundle: Foundation.Bundle? = nil) {
        fatalError()
    }
    public init(_ name: String, bundle: Foundation.Bundle? = nil, label: Text) {
        fatalError()
    }
    public init(decorative name: String, bundle: Foundation.Bundle? = nil) {
        fatalError()
    }
    public init(systemName: String) {
        fatalError()
    }
}

extension Image {
    public enum Interpolation {
        case high
        case medium
        case low
        case none
    }
}

extension Image {
    public func interpolation(_ interpolation: Interpolation) -> Image {
        return Image(provider: provider, interpolation: interpolation)
    }
}
