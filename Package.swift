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
        .package(url: "https://github.com/onevcat/Rainbow", from: "3.2.0")
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
