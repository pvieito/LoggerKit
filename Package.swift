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
    dependencies: [
        .package(url: "https://github.com/onevcat/Rainbow", from: "4.0.0")
    ],
    targets: [
        .target(
            name: "LoggerKit",
            dependencies: [
                .product(name: "Rainbow", package: "Rainbow", condition: .when(platforms: [.macOS, .iOS, .tvOS]))
            ],
            path: "LoggerKit"
        ),
        .target(
            name: "LoggerKitMac",
            dependencies: [
                .product(name: "Rainbow", package: "Rainbow", condition: .when(platforms: [.macOS]))
            ],
            path: "LoggerKitMac"
        ),
        .testTarget(
            name: "LoggerKitTests",
            dependencies: ["LoggerKit"]
        )
    ]
)
