// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "LoggerKit",
    platforms: [
        .macOS("10.13"),
        .iOS("13.0"),
        .tvOS("13.0"),
        .watchOS("9.0"),
    ],
    products: [
        .library(
            name: "LoggerKit",
            targets: ["LoggerKit"]
        ),
        .library(
            name: "LoggerKitMac",
            targets: ["LoggerKitMac"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "LoggerKit",
            dependencies: [],
            path: "LoggerKit"
        ),
        .target(
            name: "LoggerKitMac",
            dependencies: ["LoggerKit"],
            path: "LoggerKitMac"
        ),
        .testTarget(
            name: "LoggerKitTests",
            dependencies: ["LoggerKit"]
        )
    ]
)
