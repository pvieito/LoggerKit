// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "LoggerKit",
    products: [
        .library(
            name: "LoggerKit",
            targets: ["LoggerKit"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/onevcat/Rainbow", .branch("master"))
    ],
    targets: [
        .target(
            name: "LoggerKit",
            dependencies: ["Rainbow"],
            path: "LoggerKit"
        ),
        .testTarget(
            name: "LoggerKitTests",
            dependencies: ["LoggerKit"]
        )
    ]
)
