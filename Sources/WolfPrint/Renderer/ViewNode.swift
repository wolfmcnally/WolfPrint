import Foundation
import CoreGraphics

public final class ViewNode: Node {
    public var value: Drawable
    public weak var parent: ViewNode?
    public var children: [ViewNode]
    public var uuid = UUID()

    public init(value: Drawable) {
        self.value = value
        self.children = []
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
    private static let defaultSpacing: CGFloat = 8

    private func internalSpacingRequirements(for spacing: CGFloat) -> CGFloat {
        let numberOfSpacings = degree - 1
        return CGFloat(numberOfSpacings) * spacing
    }

    public func calculateChildSizes(givenWidth: CGFloat, givenHeight: CGFloat) {
        switch value {
        case let drawable as HStackDrawable:
            layoutHStackedNodes(givenWidth: givenWidth, givenHeight: givenHeight, alignment: drawable.alignment, spacing: drawable.spacing)
        case let drawable as VStackDrawable:
            layoutVStackedNodes(givenWidth: givenWidth, givenHeight: givenHeight, alignment: drawable.alignment, spacing: drawable.spacing)
        case let drawable as ZStackDrawable:
            layoutZStackedNodes(givenWidth: givenWidth, givenHeight: givenHeight, alignment: drawable.alignment)
        default:
            layoutZStackedNodes(givenWidth: givenWidth, givenHeight: givenHeight, alignment: .center)
        }
    }

    private func layoutZStackedNodes(givenWidth: CGFloat, givenHeight: CGFloat, alignment: Alignment) {
        let wantedWidth = value.wantedWidthForProposal(givenWidth, otherLength: givenHeight, node: self)
        let wantedHeight = value.wantedHeightForProposal(givenHeight, otherLength: givenWidth, node: self)
        value.size = CGSize(width: wantedWidth, height: wantedHeight)

        guard hasChildren else { return }

        var offeredWidth = givenWidth
        var offeredHeight = givenHeight
        if let padding = value as? ModifiedContentDrawable<PaddingModifier> {
            offeredWidth -= padding.modifier.value.horizontal
            offeredHeight -= padding.modifier.value.vertical
        }

        for child in children {
//            guard child.value.size == .zero else { continue } // HACK!
            child.calculateChildSizes(givenWidth: offeredWidth, givenHeight: offeredHeight)
        }
    }

    private func layoutHStackedNodes(givenWidth: CGFloat, givenHeight: CGFloat, alignment: VerticalAlignment, spacing _spacing: CGFloat?) {
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
                let wantedWidth = child.value.wantedWidthForProposal(CGFloat.greatestFiniteMagnitude, otherLength: nil, node: child)
                let wantedHeight = child.value.wantedHeightForProposal(CGFloat.greatestFiniteMagnitude, otherLength: nil, node: child)
                child.value.size = CGSize(width: wantedWidth, height: wantedHeight)

                remainingWidth -= wantedWidth

                processedNodeIndices.insert(index)
                remainingChildren -= 1
            }

            // Dividers claim the whole height that is given and set their own width
            if child.value is DividerDrawable {
                let wantedWidth = child.value.wantedWidthForProposal(givenWidth, otherLength: nil, node: child)
                let wantedHeight = child.value.wantedHeightForProposal(givenHeight, otherLength: nil, node: child)
                child.value.size = CGSize(width: wantedWidth, height: wantedHeight)

                remainingWidth -= wantedWidth

                processedNodeIndices.insert(index)
                remainingChildren -= 1
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
//                let proposedWidth = remainingWidth
                let wantedWidth = child.value.wantedWidthForProposal(proposedWidth, otherLength: givenHeight, node: child)
                // When an element fits, it should take what it needs
                if wantedWidth < proposedWidth {
                    smallOneFound = true
                    let wantedHeight = child.value.wantedHeightForProposal(givenHeight, otherLength: wantedWidth, node: child)
                    child.value.size = CGSize(width: wantedWidth, height: wantedHeight)

                    remainingWidth -= wantedWidth

                    processedNodeIndices.insert(index)
                    remainingChildren -= 1

                    child.calculateChildSizes(givenWidth: wantedWidth, givenHeight: wantedHeight)
                }
            }
            if smallOneFound == false {
                thereAreStillSmallOnes = false
            }
        }

        // Process items that won't fit
        if remainingChildren > 0 {
            let proposedWidth = remainingWidth / CGFloat(remainingChildren)
            for (index, child) in children.enumerated() {
                guard !processedNodeIndices.contains(index) else { continue }

                let wantedWidth = child.value.wantedWidthForProposal(proposedWidth, otherLength: givenHeight, node: child)
                let wantedHeight = child.value.wantedHeightForProposal(givenHeight, otherLength: proposedWidth, node: child)
                child.value.size = CGSize(width: wantedWidth, height: wantedHeight)

                remainingWidth -= proposedWidth

                processedNodeIndices.insert(index)
                remainingChildren -= 1

                child.calculateChildSizes(givenWidth: proposedWidth, givenHeight: wantedHeight)
            }
        }

        // Position element after element
        for (index, child) in children.enumerated() {
            if index > 0 {
                let previousNode = children[index - 1]
                child.value.origin.x = previousNode.value.origin.x + previousNode.value.size.width + spacing
            }
        }

        value.size.width = children.map({ $0.value.size.width }).reduce(0, +) + internalSpacingRequirements(for: spacing)
        value.size.height = children.map({ $0.value.size.height }).max() ?? 0

        // Align vertically in the given area
        let alignmentHeight = value.size.height
        switch alignment {
        case .top:
            for child in children {
                child.value.origin.y = 0
            }
        case .center:
            for child in children {
                child.value.origin.y = (alignmentHeight - child.value.size.height) / 2
            }
        case .bottom:
            for child in children {
                child.value.origin.y = alignmentHeight - child.value.size.height
            }
        case .firstTextBaseline, .lastTextBaseline:
            fatalError()
        }

    }

    private func layoutVStackedNodes(givenWidth: CGFloat, givenHeight: CGFloat, alignment: HorizontalAlignment, spacing _spacing: CGFloat?) {
        let spacing = _spacing ?? Self.defaultSpacing

        // Subtract all spacings from the height
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
                let wantedWidth = child.value.wantedWidthForProposal(CGFloat.greatestFiniteMagnitude, otherLength: nil, node: child)
                let wantedHeight = child.value.wantedHeightForProposal(CGFloat.greatestFiniteMagnitude, otherLength: nil, node: child)
                child.value.size = CGSize(width: wantedWidth, height: wantedHeight)

                remainingHeight -= wantedHeight

                processedNodeIndices.insert(index)
                remainingChildren -= 1
            }

            // Dividers claim the whole width that is given and set their own height
            if child.value is DividerDrawable {
                let wantedWidth = child.value.wantedWidthForProposal(givenWidth, otherLength: nil, node: child)
                let wantedHeight = child.value.wantedHeightForProposal(givenHeight, otherLength: nil, node: child)
                child.value.size = CGSize(width: wantedWidth, height: wantedHeight)

                remainingHeight -= wantedHeight

                processedNodeIndices.insert(index)
                remainingChildren -= 1
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
//                let proposedHeight = remainingHeight
                let wantedHeight = child.value.wantedHeightForProposal(proposedHeight, otherLength: givenWidth, node: child)
                // When an element fits, it should take what it needs
                if wantedHeight < proposedHeight {
                    smallOneFound = true
                    let wantedWidth = child.value.wantedWidthForProposal(givenWidth, otherLength: wantedHeight, node: child)
                    child.value.size = CGSize(width: wantedWidth, height: wantedHeight)

                    remainingHeight -= wantedHeight

                    processedNodeIndices.insert(index)
                    remainingChildren -= 1

                    child.calculateChildSizes(givenWidth: wantedWidth, givenHeight: wantedHeight)
                }
            }
            if smallOneFound == false {
                thereAreStillSmallOnes = false
            }
        }

        // Process items that won't fit
        if remainingChildren > 0 {
            let proposedHeight = remainingHeight / CGFloat(remainingChildren)
            for (index, child) in children.enumerated() {
                guard !processedNodeIndices.contains(index) else { continue }

                let wantedWidth = child.value.wantedWidthForProposal(givenWidth, otherLength: proposedHeight, node: child)
                let wantedHeight = child.value.wantedHeightForProposal(proposedHeight, otherLength: givenWidth, node: child)
                child.value.size = CGSize(width: wantedWidth, height: wantedHeight)

                remainingHeight -= child.value.size.height

                processedNodeIndices.insert(index)
                remainingChildren -= 1

                child.calculateChildSizes(givenWidth: wantedWidth, givenHeight: proposedHeight)
            }
        }

        // Position element after element
        for (index, child) in children.enumerated() {
            if index > 0 {
                let previousNode = children[index - 1]
                child.value.origin.y = previousNode.value.origin.y + previousNode.value.size.height + spacing
            }
        }

        value.size.width = children.map({ $0.value.size.width }).max() ?? 0
        value.size.height = children.map({ $0.value.size.height }).reduce(0, +) + internalSpacingRequirements(for: spacing)

        // Align horizontally in the given area
        let alignmentWidth = value.size.width
        switch alignment {
        case .leading:
            for child in children {
                child.value.origin.x = 0
            }
        case .center:
            for child in children {
                child.value.origin.x = (alignmentWidth - child.value.size.width) / 2
            }
        case .trailing:
            for child in children {
                child.value.origin.x = alignmentWidth - child.value.size.width
            }
        }
    }
}
