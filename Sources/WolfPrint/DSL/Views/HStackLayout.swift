import Foundation
import CoreGraphics

public struct _HStackLayout {
    public var alignment: VerticalAlignment
    public var spacing: CGFloat?
    @inlinable public init(alignment: VerticalAlignment = .center, spacing: CGFloat? = nil) {
        self.alignment = alignment
        self.spacing = spacing
    }
    public typealias Body = Never
}

extension _HStackLayout: _VariadicView_UnaryViewRoot {}
