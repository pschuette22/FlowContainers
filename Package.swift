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
    targets: [
        .target(
            name: "FlowContainers"),
        .testTarget(
            name: "FlowContainersTests",
            dependencies: ["FlowContainers"]
        ),
    ]
)
