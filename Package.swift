// swift-tools-version:4.2

import PackageDescription

// Version number can be found in Source/Danger/Danger.swift

let package = Package(
    name: "danger-swift",
    products: [
        .library(name: "Danger", type: .dynamic, targets: ["Danger"]),
        .executable(name: "danger-swift", targets: ["Runner"]),
    ],
    dependencies: [
        .package(url: "https://github.com/JohnSundell/Marathon.git", from: "3.1.0"),
        .package(url: "https://github.com/JohnSundell/ShellOut.git", from: "2.1.0"),
        .package(url: "https://github.com/nerdishbynature/octokit.swift", from: "0.9.0"),
        // Dev dependencies
        .package(url: "https://github.com/eneko/SourceDocs.git", from: "0.5.1"), // dev
        .package(url: "https://github.com/orta/Komondor.git", from: "1.0.0"), // dev
        .package(url: "https://github.com/nicklockwood/SwiftFormat.git", from: "0.35.8"), // dev
        .package(url: "https://github.com/Realm/SwiftLint.git", from: "0.28.1"), // dev
    ],
    targets: [
        .target(name: "Logger", dependencies: []),
        .target(name: "Danger", dependencies: ["ShellOut", "OctoKit", "Logger"]),
        .target(name: "RunnerLib", dependencies: ["Logger", "ShellOut"]),
        .target(name: "Runner", dependencies: ["RunnerLib", "MarathonCore", "Logger"]),
        .testTarget(name: "DangerTests", dependencies: ["Danger"]),
        .testTarget(name: "RunnerLibTests", dependencies: ["RunnerLib"]),
    ]
)

#if canImport(PackageConfig)
    import PackageConfig

    let config = PackageConfig([
        "komondor": [
            "pre-push": "swift test",
            "pre-commit": [
                "swift test",
                "swift run swiftFormat .",
                "swift run swiftlint autocorrect --path Sources/",
                "git add .",
            ],
        ],
    ])
#endif
