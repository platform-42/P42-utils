// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "P42-utils",
    products: [
        .library(
            name: "P42-utils",
            targets: ["P42-utils"]),
    ],
    targets: [
        .target(
            name: "P42-utils"),
        .testTarget(
            name: "P42-utilsTests",
            dependencies: ["P42-utils"]),
    ]
)
