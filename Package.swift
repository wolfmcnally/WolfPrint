// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WolfPrint",
    platforms: [
        .macOS(.v10_15), .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "WolfPrint",
            type: .dynamic,
            targets: ["WolfPrint"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/wolfmcnally/WolfGeometry", from: "4.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfFoundation", from: "5.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "WolfPrint",
            dependencies: ["WolfGeometry", "WolfFoundation"]),
        .testTarget(
            name: "WolfPrintTests",
            dependencies: ["WolfPrint"]),
    ]
)
