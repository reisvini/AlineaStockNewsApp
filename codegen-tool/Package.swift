// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "OpenAPIGenerator",
    platforms: [.macOS(.v13)],
    dependencies: [
        .package(url: "https://github.com/apple/swift-openapi-generator", from: "1.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "OpenAPIGenerator",
            dependencies: [
                .product(name: "swift-openapi-generator", package: "swift-openapi-generator"),
            ],
            path: "."
        )
    ]
)
