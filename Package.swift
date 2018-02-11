// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

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
