// swift-tools-version:5.10

import PackageDescription

let package = Package(
    name: "swift-webvtt-parser",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .tvOS(.v16),
        .watchOS(.v9),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "WebVTTParser", targets: ["WebVTTParser"])
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-parsing", .upToNextMajor(from: "0.13.0")),
        .package(url: "https://github.com/pointfreeco/swift-custom-dump", .upToNextMajor(from: "1.3.0"))
    ],
    targets: [
        .target(
            name: "WebVTTParser",
            dependencies: [
                .product(name: "Parsing", package: "swift-parsing")
            ],
            path: "Sources",
            resources: [
                .copy("Resources/PrivacyInfo.xcprivacy"),
                .copy("Resources/entities.json")
            ]
        ),
        .testTarget(
            name: "WebVTTParserTests",
            dependencies: [
                .target(name: "WebVTTParser"),
                .product(name: "CustomDump", package: "swift-custom-dump")
            ],
            path: "Tests",
            resources: [.copy("Resources/Subtitles")]
        )
    ],
    swiftLanguageVersions: [.v5]
)
