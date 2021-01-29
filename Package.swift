// swift-tools-version:5.2
import PackageDescription

let package = Package(
  name: "line-bot-sdk",
  products: [
    .library(name: "LineBot", targets: ["LineBot"]),
  ],
  dependencies: [
    .package(url: "https://github.com/IBM-Swift/BlueCryptor.git", from: "1.0.0"),
  ],
  targets: [
    .target(name: "LineBot", dependencies: [
      .product(name: "Cryptor", package: "Cryptor"),
    ])
    .testTarget(name: "LineBotTests", dependencies: [
      .target(name: "LineBot"),
    ])
  ]
)

