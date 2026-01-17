// swift-tools-version:5.4

import Foundation
import PackageDescription

var sources = ["src/parser.c"]
if FileManager.default.fileExists(atPath: "src/scanner.c") {
    sources.append("src/scanner.c")
}

let package = Package(
    name: "TreeSitterMetal",
    products: [
        .library(name: "TreeSitterMetal", targets: ["TreeSitterMetal"]),
        .executable(name: "TreeSitterMetalTests", targets: ["TreeSitterMetalTests"]),
    ],
    dependencies: [
        .package(
            name: "SwiftTreeSitter", url: "https://github.com/tree-sitter/swift-tree-sitter",
            from: "0.9.0")
    ],
    targets: [
        .target(
            name: "TreeSitterMetal",
            dependencies: [],
            path: ".",
            sources: sources,
            resources: [
                .copy("queries")
            ],
            publicHeadersPath: "bindings/swift",
            cSettings: [.headerSearchPath("src")]
        ),
        .executableTarget(
            name: "TreeSitterMetalTests",
            dependencies: [
                "SwiftTreeSitter",
                "TreeSitterMetal",
            ],
            path: "bindings/swift/TreeSitterMetalTests"
        ),
    ],
    cLanguageStandard: .c11
)
