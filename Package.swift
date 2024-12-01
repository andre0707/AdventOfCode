// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AdventOfCode",
    platforms: [
        .macOS(SupportedPlatform.MacOSVersion.v10_13),
        .iOS(SupportedPlatform.IOSVersion.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "AdventOfCode2020",
            targets: ["AdventOfCode2020"]),
        
            .library(
                name: "AdventOfCode2021",
                targets: ["AdventOfCode2021"]),
        
            .library(
                name: "AdventOfCode2022",
                targets: ["AdventOfCode2022"]),
        
            .library(
                name: "AdventOfCode2023",
                targets: ["AdventOfCode2023"]),
        
            .library(
                name: "AdventOfCode2024",
                targets: ["AdventOfCode2024"]),
        
            .library(
                name: "AdventOfCode2025",
                targets: ["AdventOfCode2025"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "AdventOfCode2020",
            dependencies: [],
            exclude: ["Tasks"],
            resources: [
                .copy("Resources")
            ]),
        
            .target(
                name: "AdventOfCode2021",
                dependencies: [],
                exclude: ["Tasks"],
                resources: [
                    .copy("Resources")
                ]),
        
            .target(
                name: "AdventOfCode2022",
                dependencies: [],
                exclude: ["Tasks"],
                resources: [
                    .copy("Resources")
                ]),
        
            .target(
                name: "AdventOfCode2023",
                dependencies: [],
                exclude: ["Tasks"],
                resources: [
                    .copy("Resources")
                ]),
        
            .target(
                name: "AdventOfCode2024",
                dependencies: [],
                exclude: ["Tasks"],
                resources: [
                    .copy("Resources")
                ]),
        
            .target(
                name: "AdventOfCode2025",
                dependencies: [],
                exclude: ["Tasks"],
                resources: [
                    .copy("Resources")
                ]),
        
        
            .testTarget(
                name: "AdventOfCodeTests",
                dependencies: [
                    "AdventOfCode2020",
                    "AdventOfCode2021",
                    "AdventOfCode2022",
                    "AdventOfCode2023",
                    "AdventOfCode2024",
                    "AdventOfCode2025",
                ]),
    ]
)
