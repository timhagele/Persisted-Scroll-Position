// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Persisted Scroll Position",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Persisted Scroll Position",
            targets: ["Persisted Scroll Position"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Persisted Scroll Position"),
        .testTarget(
            name: "Persisted Scroll PositionTests",
            dependencies: ["Persisted Scroll Position"]),
    ]
)
