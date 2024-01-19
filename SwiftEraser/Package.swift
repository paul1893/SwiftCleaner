// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "SwiftEraser",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "SwiftEraser",
            targets: ["SwiftEraser"]
        ),
        .executable(
            name: "SwiftEraserCommandLineTool",
            targets: ["SwiftEraserCommandLineTool"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-argument-parser",
            from: "1.2.3"
        ),
        .package(
            url: "https://github.com/apple/swift-syntax",
            from: "509.1.0"
        ),
    ],
    targets: [
        .executableTarget(
            name: "SwiftEraserCommandLineTool",
            dependencies: ["SwiftEraser"],
            path: "Sources/SwiftEraserCommandLineTool"
        ),
        .target(
            name: "SwiftEraser",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftOperators", package: "swift-syntax"),
                .product(name: "SwiftParser", package: "swift-syntax"),
                // .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
            path: "Sources/SwiftEraser"
        ),
        .testTarget(
            name: "SwiftEraserTests",
            dependencies: [
                "SwiftEraser"
            ]
        ),
    ]
)
