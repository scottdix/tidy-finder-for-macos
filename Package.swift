// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TidyFinder",
    platforms: [
        .macOS(.v11)
    ],
    products: [
        // Library that can be imported by external projects
        .library(
            name: "TidyFinderCore",
            targets: ["TidyFinderCore"]
        ),
        // Executable CLI tool
        .executable(
            name: "tidyfinder",
            targets: ["tidyfinder"]
        )
    ],
    dependencies: [],
    targets: [
        // Library target containing core logic
        .target(
            name: "TidyFinderCore",
            dependencies: []
        ),
        // Executable target that depends on the library
        .executableTarget(
            name: "tidyfinder",
            dependencies: ["TidyFinderCore"]
        ),
        // Test target
        .testTarget(
            name: "TidyFinderTests",
            dependencies: ["TidyFinderCore"]
        )
    ]
)