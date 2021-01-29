// swift-tools-version:5.2
import PackageDescription

let package = Package(
  name: "line-bot-sdk",
  products: [
    .library(name: "LineBot", targets: ["LineBot"]),
  ],
  dependencies: [
    .package(url: "https://github.com/IBM-Swift/BlueCryptor.git", from: "1.0.0")
  ],
  targets: [
    .target(name: "LineBot", dependencies: ["Cryptor"]),
    .testTarget(name: "LineBotTests", dependencies: ["LineBot"]),
  ]
)

