// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FlowContainers",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "FlowContainers",
            targets: ["FlowContainers"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "FlowContainers",
            dependencies: []),
        .testTarget(
            name: "FlowContainersTests",
            dependencies: ["FlowContainers"])
    ]
)
