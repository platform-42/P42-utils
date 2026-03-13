// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "P42Utils",
    platforms: [
        .iOS(.v17),
        .watchOS(.v10),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "P42Utils",
            targets: ["P42Utils"]),
    ],
    dependencies: [
        .package(url: "https://github.com/platform-42/P42Extensions.git", from: "6.0.0")
    ],
    targets: [
        .target(
            name: "P42Utils",
            dependencies: [
                .product(name: "P42Extensions", package: "P42Extensions")
            ]
        ),
    ]
)

