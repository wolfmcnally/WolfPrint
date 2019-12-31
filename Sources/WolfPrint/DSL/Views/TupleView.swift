public struct TupleView<T>: View {
    public var content: T
    public typealias Body = Never

    public init(_ content: T) {
        self.content = content
    }
}

extension TupleView {
    public var body: Never {
        fatalError()
    }
}

extension TupleView {
    public static func _makeView(view: _GraphValue<TupleView<T>>, inputs: _ViewInputs) -> _ViewOutputs {
        fatalError()
    }

    public static func _makeViewList(view: _GraphValue<TupleView<T>>, inputs: _ViewListInputs) -> _ViewListOutputs {
        fatalError()
    }
}
