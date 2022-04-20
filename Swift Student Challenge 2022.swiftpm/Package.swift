// swift-tools-version: 5.5

// WARNING:
// This file is automatically generated.
// Do not edit it by hand because the contents will be replaced.

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "Swift Student Challenge 2022",
    platforms: [
        .iOS("15.2")
    ],
    products: [
        .iOSApplication(
            name: "Swift Student Challenge 2022",
            targets: ["AppModule"],
            bundleIdentifier: "com.garv.Swift-Student-Challenge-2022",
            teamIdentifier: "J55VMN7UVW",
            displayVersion: "1.0",
            bundleVersion: "1",
            iconAssetName: "AppIcon",
            accentColorAssetName: "AccentColor",
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft,
                .portraitUpsideDown(.when(deviceFamilies: [.pad]))
            ]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/joogps/SlideOverCard", "2.0.0"..<"3.0.0")
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            dependencies: [
                .product(name: "SlideOverCard", package: "slideovercard")
            ],
            path: ".",
            resources: [
                .process("Resources")
            ]
        )
    ]
)