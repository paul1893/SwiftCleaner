// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "SwiftCleaner",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "SwiftCleaner", targets: ["SwiftCleaner"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-argument-parser.git",
            .upToNextMajor(from: "1.4.0")
        ),
        .package(
            path: "../SwiftEraser"
        )
    ],
    targets: [
        .executableTarget(
            name: "SwiftCleaner",
            dependencies: [
                .product(name: "SwiftEraser", package: "SwiftEraser"),
            ],
            resources: [.copy("Resources/periphery")]
        )
    ]
)
