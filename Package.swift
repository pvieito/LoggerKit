// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "LoggerKit",
    products: [
        .library(name: "LoggerKit", targets: ["LoggerKit"]),
    ],
    targets: [
        .target(name: "LoggerKit", path: "LoggerKit")
    ]
)
