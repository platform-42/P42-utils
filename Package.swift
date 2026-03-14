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
    targets: [
        .target(
            name: "P42Utils"
        )
    ]
)

