// swift-tools-version:4.0
import PackageDescription

let package = Package(
  name: "LineBot",
  products: [
    .library(name: "LineBot", targets: ["LineBot"]),
  ],
  dependencies: [
    .package(url: "https://github.com/vapor/vapor.git", .upToNextMajor(from: "2.1.0")),
  ],
  targets: [
    .target(name: "LineBot", dependencies: ["Vapor"]),
  ]
)

