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
    fileprivate static func make(red: Double, green: Double, blue: Double, alpha: Double = 1) -> CGColor {
        let colorSpace = CGColorSpace(name: CGColorSpace.sRGB)!
        let components = [CGFloat(red), CGFloat(green), CGFloat(blue), CGFloat(alpha)]
        return CGColor(colorSpace: colorSpace, components: components)!
    }

    fileprivate static func make(bytesRed red: Int, green: Int, blue: Int, alpha: Int = 255) -> CGColor {
        make(red: Double(red)/255, green: Double(green)/255, blue: Double(blue)/255, alpha: Double(alpha)/255)
    }

    fileprivate static func make(displayP3red red: Double, green: Double, blue: Double, alpha: Double = 1) -> CGColor {
        let colorSpace = CGColorSpace(name: CGColorSpace.displayP3)!
        let components = [CGFloat(red), CGFloat(green), CGFloat(blue), CGFloat(alpha)]
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
        case .clear:        return CGColor.make(bytesRed: 0, green: 0, blue: 0, alpha: 0)
        case .black:        return CGColor.make(bytesRed: 0, green: 0, blue: 0)
        case .white:        return CGColor.make(bytesRed: 1, green: 1, blue: 1)
        case .gray:         return CGColor.make(bytesRed: 142, green: 142, blue: 147)

        case .red:          return CGColor.make(bytesRed: 254, green: 39, blue: 97)
        case .green:        return CGColor.make(bytesRed: 39, green: 213, blue: 102)
        case .blue:         return CGColor.make(bytesRed: 46, green: 126, blue: 248)

        case .orange:       return CGColor.make(bytesRed: 253, green: 159, blue: 55)
        case .yellow:       return CGColor.make(bytesRed: 252, green: 217, blue: 69)
        case .pink:         return CGColor.make(bytesRed: 254, green: 39, blue: 97)
        case .purple:       return CGColor.make(bytesRed: 194, green: 74, blue: 235)

        case .primary:      return CGColor.make(bytesRed: 255, green: 255, blue: 255)
        case .secondary:    return CGColor.make(bytesRed: 141, green: 141, blue: 147)
        case .accentColor:  return CGColor.make(bytesRed: 44, green: 114, blue: 248)
        }
    }

    var cgColorLight: CGColor {
        switch value {
        case .clear:        return CGColor.make(bytesRed: 0, green: 0, blue: 0, alpha: 0)
        case .black:        return CGColor.make(bytesRed: 0, green: 0, blue: 0)
        case .white:        return CGColor.make(bytesRed: 1, green: 1, blue: 1)
        case .gray:         return CGColor.make(bytesRed: 142, green: 142, blue: 147)

        case .red:          return CGColor.make(bytesRed: 254, green: 47, blue: 58)
        case .green:        return CGColor.make(bytesRed: 45, green: 203, blue: 101)
        case .blue:         return CGColor.make(bytesRed: 44, green: 114, blue: 248)

        case .orange:       return CGColor.make(bytesRed: 253, green: 149, blue: 50)
        case .yellow:       return CGColor.make(bytesRed: 253, green: 206, blue: 64)
        case .pink:         return CGColor.make(bytesRed: 254, green: 23, blue: 88)
        case .purple:       return CGColor.make(bytesRed: 178, green: 67, blue: 216)

        case .primary:      return CGColor.make(bytesRed: 0, green: 0, blue: 0)
        case .secondary:    return CGColor.make(bytesRed: 138, green: 138, blue: 142)
        case .accentColor:  return CGColor.make(bytesRed: 44, green: 114, blue: 248)
        }
    }
}
