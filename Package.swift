// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LoggerKit",
    products: [
        .library(name: "LoggerKit", type: .static, targets: ["LoggerKit"]),
    ],
    dependencies: [
        
    ],
    targets: [
        .target(name: "LoggerKit", dependencies: [], path: "LoggerKit")
    ]
)
