// swift-tools-version:3.0
import PackageDescription

let package = Package(
  name: "LineBot",
  dependencies: [
    .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 2),
  ]
)
