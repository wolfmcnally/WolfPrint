//
//  File.swift
//  
//
//  Created by Wolf McNally on 12/28/19.
//

import Foundation
import CoreGraphics

public class HostingContext<Content: View> {
    private var rootView: Content
    private var context: CGContext
    private var displaySize: CGSize
    private var debugViews: Bool

    public var rootNode: ViewNode

    public init(rootView: Content, context: CGContext, displaySize: CGSize, debugViews: Bool = false) {
        self.rootView = rootView
        self.context = context
        self.displaySize = displaySize
        self.debugViews = debugViews
        self.rootNode = ViewNode(value: RootDrawable())
    }

    public func draw() {
        self.rootNode = ViewNode(value: RootDrawable())
        let rootViewBody = rootView.body
        if let a = rootViewBody as? ViewBuildable {
            a.buildDebugTree(tree: &rootNode, parent: rootNode)
        }

        calculateTreeSizes()
        print(rootNode.lineBasedDescription.replacingOccurrences(of: "WolfPrint.", with: ""))
        drawNodesRecursively(node: rootNode)
    }

    private func calculateTreeSizes() {
        rootNode.calculateSize(givenWidth: displaySize.width, givenHeight: displaySize.height)
        rootNode.value.size = displaySize
    }

    private func drawNodesRecursively(node: ViewNode) {
        guard node.value.size.width > 0 else { return }

        let parentPadding = (node.parent?.value as? ModifiedContentDrawable<PaddingModifier>)?.modifier.value ?? EdgeInsets()

        var foregroundColor: Color?
        for ancestor in node.ancestors {
            if let color = (ancestor.value as? ModifiedContentDrawable<_EnvironmentKeyWritingModifier<Color?>>)?.modifier.value {
                foregroundColor = color
                break
            }
        }

        var colorScheme: ColorScheme = .light
        for ancestor in node.ancestors {
            if let scheme = (ancestor.value as? ModifiedContentDrawable<_EnvironmentKeyWritingModifier<ColorScheme>>)?.modifier.value {
                colorScheme = scheme
                break
            }
        }

        let width = node.value.size.width
        let height = node.value.size.height

        let x = node.ancestors.reduce(0, { $0 + $1.value.origin.x }) + node.value.origin.x + parentPadding.leading
        let y = node.ancestors.reduce(0, { $0 + $1.value.origin.y }) + node.value.origin.y + parentPadding.top

        let rect = CGRect(x: x, y: y, width: width, height: height)

        if let colorNode = node.value as? ColorDrawable {
            context.setFillColor(colorNode.color.cgColor(for: colorScheme))
            context.fill(rect)
        }

        if let backgroundNode = node.value as? ModifiedContentDrawable<_BackgroundModifier<Color>> {
            context.setFillColor(backgroundNode.modifier.background.cgColor(for: colorScheme))
            context.fill(rect)
        }

        if let textNode = node.value as? TextDrawable {
            var textColor = foregroundColor ?? Color.primary
            textNode.modifiers.forEach {
                if case let .color(color) = $0, let c = color {
                    textColor = c
                }
            }

//            var textFont = inheritedFont
//            textNode.modifiers.forEach {
//                if case let .font(font) = $0, let f = font {
//                    textFont = f
//                }
//            }

            let attributes: [NSAttributedString.Key : Any] = [
                .font: textNode.resolvedFont.osFont,
                .foregroundColor: textColor.uiColor(for: colorScheme)
            ]
            (textNode.text as NSString).draw(with: rect, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        }

        if let imageNode = node.value as? ImageDrawable {
//            let uiColor = (foregroundColor ?? Color.primary).uiColor(for: colorScheme)
            imageNode.uiImage.draw(at: rect.origin)
        }

        if let _ = node.value as? CircleDrawable {
            let diameter = min(width, height)
            let radius = diameter / 2
            var offsetX: CGFloat = 0
            if width > diameter {
                offsetX = (width - diameter) / 2
            }
            var offsetY: CGFloat = 0
            if height > diameter {
                offsetY = (height - diameter) / 2
            }
            let center = CGPoint(x: x + radius + offsetX, y: y + radius + offsetY)
            let r = CGRect(origin: center, size: .zero)
            let r2 = r.insetBy(dx: -radius, dy: -radius)

            context.saveGState()
            context.setFillColor((foregroundColor ?? Color.primary).cgColor(for: colorScheme))
            context.fillEllipse(in: r2);
            context.restoreGState()
        }

        if let _ = node.value as? RectangleDrawable {
            context.saveGState()
            context.setFillColor((foregroundColor ?? Color.primary).cgColor(for: colorScheme))
            context.fill(rect)
            context.restoreGState()
        }

        if let _ = node.value as? DividerDrawable {
            context.saveGState()
            context.setFillColor((foregroundColor ?? Color.gray).cgColor(for: colorScheme))
            context.fill(rect)
            context.restoreGState()
        }

//        if let button = node.value as? ButtonDrawable {
//            let frame = CGRect(x: x, y: y, width: width, height: height)
//            let action = Interaction(frame: frame, action: button.action)
//            interactiveAreas.append(action)
//        }

        if debugViews {
            context.saveGState()
            context.setLineDash(phase: 0, lengths: [2, 3])
            context.setLineWidth(1)
            context.setStrokeColor(Color.purple.cgColor(for: colorScheme))
            context.stroke(rect)
            context.restoreGState()
        }

        if node.isBranch {
            for child in node.children {
                drawNodesRecursively(node: child)
            }
        }
    }
}
