// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TidyFinder",
    platforms: [
        .macOS(.v11)
    ],
    products: [
        .executable(
            name: "tidyfinder",
            targets: ["TidyFinder"]
        )
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "TidyFinder",
            dependencies: []
        ),
        .testTarget(
            name: "TidyFinderTests",
            dependencies: ["TidyFinder"]
        )
    ]
)