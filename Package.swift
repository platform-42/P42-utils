// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "P42-utils",
    platforms: [
        .iOS(.v16),
        .watchOS(.v6),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "P42-utils",
            targets: ["P42-utils"]),
    ],
    dependencies: [
        .package(url: "https://github.com/platform-42/P42-extensions.git", from: "4.0.0")
    ],
    targets: [
        .target(
            name: "P42-utils",
            dependencies: [
                "P42-extensions"
            ],
            path: "Sources/P42-utils"
        ),

    ]
)
