// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FlowContainers",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "FlowContainers",
            targets: ["FlowContainers"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "FlowContainers",
            exclude: [
                "docs/",
                "Sample/",
                "FlowContainers/",
                "generate-docs.command"
            ]
        ),
        .testTarget(
            name: "FlowContainersTests",
            dependencies: ["FlowContainers"]
        ),
    ]
)
