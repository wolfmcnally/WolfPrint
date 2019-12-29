import Foundation
import CoreGraphics

public final class ViewNode: Node {
//    public typealias Value = Drawable
    public var value: Drawable
    public weak var parent: ViewNode?
    public var children: [ViewNode]
//    public var spacing: CGFloat = 8
    public var uuid = UUID()
    public var processor: String

    public init(value: Drawable) {
        self.value = value
        self.children = []
        self.processor = ""
    }
}

extension ViewNode: Equatable {
    public static func == (lhs: ViewNode, rhs: ViewNode) -> Bool {
        return lhs.uuid == rhs.uuid && lhs.parent == rhs.parent
    }
}

extension ViewNode: CustomStringConvertible {
    public var description: String {
        return "\(value)"
    }
}

extension ViewNode {
    private static let defaultSpacing: CGFloat = 0

    private func internalSpacingRequirements(for spacing: CGFloat) -> CGFloat {
        let numberOfSpacings = degree - 1
        return CGFloat(numberOfSpacings) * spacing
    }

    public func calculateSize(givenWidth: CGFloat, givenHeight: CGFloat) {
        guard isBranch else { return }

        switch value {
        case let drawable as HStackDrawable:
            calculateNodeWithHorizontallyStackedNodes(givenWidth: givenWidth, givenHeight: givenHeight, alignment: drawable.alignment, spacing: drawable.spacing)
        case let drawable as VStackDrawable:
            calculateNodeWithVerticallyStackedNodes(givenWidth: givenWidth, givenHeight: givenHeight, alignment: drawable.alignment, spacing: drawable.spacing)
        case let drawable as ZStackDrawable:
            calculateNodeWithZStackedNodes(givenWidth: givenWidth, givenHeight: givenHeight, alignment: drawable.alignment)
        default:
            calculateNodeWithZStackedNodes(givenWidth: givenWidth, givenHeight: givenHeight, alignment: .center)
        }
    }

    private func calculateNodeWithZStackedNodes(givenWidth: CGFloat, givenHeight: CGFloat, alignment: Alignment) {
        for child in children {
            child.processor = "* ZStack"
            child.calculateSize(givenWidth: givenWidth, givenHeight: givenHeight)
            if !child.value.passthrough {
                let wantedWidth = child.value.wantedWidthForProposal(givenWidth, otherLength: givenHeight)
                let wantedHeight = child.value.wantedHeightForProposal(givenHeight, otherLength: givenWidth)
                child.value.size.width = wantedWidth
                child.value.size.height = wantedHeight
            }
        }

        value.size.width = children.map({ $0.value.size.width }).max()!
        value.size.height = children.map({ $0.value.size.height }).max()!

        if let v = value as? ModifiedContentDrawable<PaddingModifier> {
            value.size.width += v.modifier.value.horizontal
            value.size.height += v.modifier.value.vertical
        }

        processor = "ZStack"
    }

    private func calculateNodeWithHorizontallyStackedNodes(givenWidth: CGFloat, givenHeight: CGFloat, alignment: VerticalAlignment, spacing _spacing: CGFloat?) {
        let spacing = _spacing ?? Self.defaultSpacing

        // Substract all spacings from the width
        var remainingWidth = givenWidth - internalSpacingRequirements(for: spacing)

        // Keep record of elements that we already processed
        var processedNodeIndices = Set<Int>()

        // Keep record of the number of unprocessed children
        var remainingChildren = degree

        // Least flexible items first (elements with an intrinsic width [and maybe height])
        for (index, child) in children.enumerated() {
            guard !processedNodeIndices.contains(index) else { continue }

            // Images have their own intrinsic size
            if child.value is ImageDrawable {
                let width = child.value.wantedWidthForProposal(CGFloat.greatestFiniteMagnitude, otherLength: nil)
                child.value.size.height = child.value.wantedHeightForProposal(CGFloat.greatestFiniteMagnitude, otherLength: nil)
                child.value.size.width = width
                remainingWidth -= width

                processedNodeIndices.insert(index)
                remainingChildren -= 1
                child.processor = "* HStack"
            }

            // Dividers claim the whole height that is given and set their own width
            if child.value is DividerDrawable {
                let width = child.value.wantedWidthForProposal(givenWidth, otherLength: nil)
                child.value.size.height = child.value.wantedHeightForProposal(givenHeight, otherLength: nil)
                child.value.size.width = width
                remainingWidth -= width

                processedNodeIndices.insert(index)
                remainingChildren -= 1
                child.processor = "* HStack"
            }
        }

        // Process items that would fit inside the proposal
        // loop and repeat until only elements that wont fit remain
        var thereAreStillSmallOnes = true
        while thereAreStillSmallOnes {
            var smallOneFound = false
            for (index, child) in children.enumerated() {
                guard !processedNodeIndices.contains(index) else { continue }

                let proposedWidth = remainingWidth / CGFloat(remainingChildren)
                let wantedWidth = child.value.wantedWidthForProposal(proposedWidth, otherLength: givenHeight)
                // When an element fits, it should take what it needs
                if proposedWidth > wantedWidth {
                    smallOneFound = true
                    let wantedHeight = child.value.wantedHeightForProposal(givenHeight, otherLength: wantedWidth)
                    child.value.size.height = wantedHeight
                    child.value.size.width = wantedWidth
                    remainingWidth -= wantedWidth

                    processedNodeIndices.insert(index)
                    remainingChildren -= 1
                    child.processor = "* HStack"

                    child.calculateSize(givenWidth: wantedWidth, givenHeight: wantedHeight)
                }
            }
            if smallOneFound == false {
                thereAreStillSmallOnes = false
            }
        }

        // Process items that wont fit
        if remainingChildren > 0 {
            let proposedWidth = remainingWidth / CGFloat(remainingChildren)
            for (index, child) in children.enumerated() {
                guard !processedNodeIndices.contains(index) else { continue }

                let wantedHeight = child.value.wantedHeightForProposal(givenHeight, otherLength: proposedWidth)
                child.value.size.height = wantedHeight
                child.value.size.width = proposedWidth
                remainingWidth -= proposedWidth

                processedNodeIndices.insert(index)
                remainingChildren -= 1
                child.processor = "* HStack"

                child.calculateSize(givenWidth: proposedWidth, givenHeight: wantedHeight)
            }
        }

        // Position element after element
        for (index, child) in children.enumerated() {
            if index > 0 {
                let previousNode = children[index - 1]
                child.value.origin.x = previousNode.value.origin.x + previousNode.value.size.width + spacing
            }
        }

        switch alignment {
        case .top:
            for child in children {
                child.value.origin.y = 0
            }
        case .center:
            for child in children {
                child.value.origin.y = (givenHeight - child.value.size.height) / 2
            }
        case .bottom:
            for child in children {
                child.value.origin.y = givenHeight - child.value.size.height
            }
        case .firstTextBaseline, .lastTextBaseline:
            fatalError()
        }

        value.size.width = children.map({ $0.value.size.width }).reduce(0, +) + internalSpacingRequirements(for: spacing)
        value.size.height = children.map({ $0.value.size.height }).max()!

        // Center horizontally in the given area
        let offset = (givenWidth - value.size.width) / 2
        for child in children {
            child.value.origin.x += offset
        }

        processor = "HStack"
    }

    private func calculateNodeWithVerticallyStackedNodes(givenWidth: CGFloat, givenHeight: CGFloat, alignment: HorizontalAlignment, spacing _spacing: CGFloat?) {
        let spacing = _spacing ?? Self.defaultSpacing

        // Substract all spacings from the height
        var remainingHeight = givenHeight - internalSpacingRequirements(for: spacing)

        // Keep record of elements that we already processed
        var processedNodeIndices = Set<Int>()

        // Keep record of the number of unprocessed children
        var remainingChildren = degree

        // Least flexible items first (elements with an intrinsic height [and maybe width])
        for (index, child) in children.enumerated() {
            guard !processedNodeIndices.contains(index) else { continue }

            // Images have their own intrinsic size
            if child.value is ImageDrawable {
                let height = child.value.wantedHeightForProposal(CGFloat.greatestFiniteMagnitude, otherLength: nil)
                child.value.size.width = child.value.wantedWidthForProposal(CGFloat.greatestFiniteMagnitude, otherLength: nil)
                child.value.size.height = height
                remainingHeight -= height

                processedNodeIndices.insert(index)
                remainingChildren -= 1
                child.processor = "* VStack"
            }

            // Dividers claim the whole width that is given and set their own height
            if child.value is DividerDrawable {
                let height = child.value.wantedHeightForProposal(givenHeight, otherLength: nil)
                child.value.size.width = child.value.wantedWidthForProposal(givenWidth, otherLength: nil)
                child.value.size.height = height
                remainingHeight -= height

                processedNodeIndices.insert(index)
                remainingChildren -= 1
                child.processor = "* VStack"
            }
        }

        // Process items that would fit inside the proposal
        // loop and repeat until only elements that wont fit remain
        var thereAreStillSmallOnes = true
        while thereAreStillSmallOnes {
            var smallOneFound = false
            for (index, child) in children.enumerated() {
                guard !processedNodeIndices.contains(index) else { continue }

                let proposedHeight = remainingHeight / CGFloat(remainingChildren)
                let wantedHeight = child.value.wantedHeightForProposal(proposedHeight, otherLength: givenWidth)
                // When an element fits, it should take what it needs
                if proposedHeight > wantedHeight {
                    smallOneFound = true
                    let wantedWidth = child.value.wantedWidthForProposal(givenWidth, otherLength: wantedHeight)
                    child.value.size.width = wantedWidth
                    child.value.size.height = wantedHeight
                    remainingHeight -= wantedHeight

                    processedNodeIndices.insert(index)
                    remainingChildren -= 1
                    child.processor = "* VStack"

                    child.calculateSize(givenWidth: wantedWidth, givenHeight: wantedHeight)
                }
            }
            if smallOneFound == false {
                thereAreStillSmallOnes = false
            }
        }

        // Process items that wont fit
        if remainingChildren > 0 {
            print("🔥 remainingChildren: \(remainingChildren)")
            let proposedHeight = remainingHeight / CGFloat(remainingChildren)
            for (index, child) in children.enumerated() {
                guard !processedNodeIndices.contains(index) else { continue }

                let wantedWidth = child.value.wantedWidthForProposal(givenWidth, otherLength: proposedHeight)
                child.value.size.width = wantedWidth
                child.value.size.height = proposedHeight
                remainingHeight -= child.value.size.height

                processedNodeIndices.insert(index)
                remainingChildren -= 1
                child.processor = "* VStack"

                child.calculateSize(givenWidth: wantedWidth, givenHeight: proposedHeight)
                print("🔥 \(child.value)")
            }
        }

        // Position element after element
        for (index, child) in children.enumerated() {
            if index > 0 {
                let previousNode = children[index - 1]
                child.value.origin.y = previousNode.value.origin.y + previousNode.value.size.height + spacing
            }
        }

        // Align horizontally in the given area
        switch alignment {
        case .leading:
            for child in children {
                child.value.origin.x = 0
            }
        case .center:
            for child in children {
                child.value.origin.x = (givenWidth - child.value.size.width) / 2
            }
        case .trailing:
            for child in children {
                child.value.origin.x = givenWidth - child.value.size.width
            }
        }

        value.size.width = children.map({ $0.value.size.width }).max()!
        value.size.height = children.map({ $0.value.size.height }).reduce(0, +) + internalSpacingRequirements(for: spacing)

        // Center vertically in the given area
        let offset = (givenHeight - value.size.height) / 2
        for child in children {
            child.value.origin.y += offset
        }

        processor = "VStack"
    }
}
