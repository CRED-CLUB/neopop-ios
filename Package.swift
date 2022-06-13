// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "neopop-ios",
    platforms: [.iOS(.v11)],
    products: [
        .library(
            name: "NeoPop",
            targets: ["NeoPop"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "NeoPop",
            dependencies: []),
        .testTarget(
            name: "NeoPopTests",
            dependencies: ["NeoPop"])
    ],
    swiftLanguageVersions: [.v5]
)
