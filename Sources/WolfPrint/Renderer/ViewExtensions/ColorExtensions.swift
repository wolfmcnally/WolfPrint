import UIKit

extension Color: ViewBuildable {
    public func buildDebugTree(tree: inout ViewNode, parent: ViewNode) {
        parent.addChild(node: ViewNode(value: ColorDrawable(color: self)))
    }
}

extension Color {
    public func uiColor(for colorScheme: ColorScheme) -> UIColor {
        UIColor(cgColor: cgColor(for: colorScheme))
    }

    public func cgColor(for colorScheme: ColorScheme) -> CGColor {
        switch provider {
        case let provider as _Resolved:
            return CGColor.make(red: provider.linearRed, green: provider.linearGreen, blue: provider.linearBlue)
        case let provider as DisplayP3:
            return CGColor.make(displayP3red: provider.red, green: provider.green, blue: provider.blue)
        case let provider as SystemColorType:
            return provider.cgColor(for: colorScheme)
        default:
            fatalError()
        }
    }
}

extension CGColor {
    fileprivate static func make(red: Double, green: Double, blue: Double) -> CGColor {
        let colorSpace = CGColorSpace(name: CGColorSpace.linearSRGB)!
        let components = [CGFloat(red), CGFloat(green), CGFloat(blue), CGFloat(1)]
        return CGColor(colorSpace: colorSpace, components: components)!
    }

    fileprivate static func make(displayP3red red: Double, green: Double, blue: Double) -> CGColor {
        let colorSpace = CGColorSpace(name: CGColorSpace.displayP3)!
        let components = [CGFloat(red), CGFloat(green), CGFloat(blue), CGFloat(1)]
        return CGColor(colorSpace: colorSpace, components: components)!
    }
}

extension SystemColorType {
    public func cgColor(for colorScheme: ColorScheme) -> CGColor {
        switch colorScheme {
        case .light:
            return cgColorLight
        case .dark:
            return cgColorDark
        }
    }

    var cgColorDark: CGColor {
        switch value {
        case .clear:
            return CGColor.make(red: 0, green: 0, blue: 0)
        case .black:
            return CGColor.make(red: 0, green: 0, blue: 0)
        case .white:
            return CGColor.make(red: 1, green: 1, blue: 1)
        case .gray:
            return CGColor.make(red: 142/255.0, green: 142/255.0, blue: 147/255.0)
        case .red:
            return CGColor.make(red: 255/255.0, green: 69/255.0, blue: 58/255.0)
        case .green:
            return CGColor.make(red: 49/255.0, green: 209/255.0, blue: 88/255.0)
        case .blue:
            return CGColor.make(red: 10/255.0, green: 132/255.0, blue: 255/255.0)
        case .orange:
            return CGColor.make(red: 255/255.0, green: 159/255.0, blue: 10/255.0)
        case .yellow:
            return CGColor.make(red: 255/255.0, green: 214/255.0, blue: 10/255.0)
        case .pink:
            return CGColor.make(red: 255/255.0, green: 55/255.0, blue: 95/255.0)
        case .purple:
            return CGColor.make(red: 191/255.0, green: 90/255.0, blue: 242/255.0)
        case .primary:
            return CGColor.make(red: 255/255.0, green: 255/255.0, blue: 255/255.0)
        case .secondary:
            return CGColor.make(red: 141/255.0, green: 141/255.0, blue: 147/255.0)
        case .accentColor:
            return CGColor.make(red: 0/255.0, green: 122/255.0, blue: 255/255.0)
        }
    }

    var cgColorLight: CGColor {
        switch value {
        case .clear:
            return CGColor.make(red: 0, green: 0, blue: 0)
        case .black:
            return CGColor.make(red: 0, green: 0, blue: 0)
        case .white:
            return CGColor.make(red: 1, green: 1, blue: 1)
        case .gray:
            return CGColor.make(red: 138/255.0, green: 138/255.0, blue: 142/255.0)
        case .red:
            return CGColor.make(red: 255/255.0, green: 59/255.0, blue: 48/255.0)
        case .green:
            return CGColor.make(red: 53/255.0, green: 199/255.0, blue: 89/255.0)
        case .blue:
            return CGColor.make(red: 0/255.0, green: 122/255.0, blue: 255/255.0)
        case .orange:
            return CGColor.make(red: 255/255.0, green: 149/255.0, blue: 0/255.0)
        case .yellow:
            return CGColor.make(red: 255/255.0, green: 204/255.0, blue: 0/255.0)
        case .pink:
            return CGColor.make(red: 255/255.0, green: 45/255.0, blue: 85/255.0)
        case .purple:
            return CGColor.make(red: 175/255.0, green: 82/255.0, blue: 222/255.0)
        case .primary:
            return CGColor.make(red: 0/255.0, green: 0/255.0, blue: 0/255.0)
        case .secondary:
            return CGColor.make(red: 138/255.0, green: 138/255.0, blue: 142/255.0)
        case .accentColor:
            return CGColor.make(red: 0/255.0, green: 122/255.0, blue: 255/255.0)
        }
    }
}
