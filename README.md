# Line Bot SDK Swift

[![MIT License](https://img.shields.io/badge/license-MIT-brightgreen.svg)](LICENSE)
[![Continuous Integration](https://img.shields.io/badge/build-passing-brightgreen.svg)](https://circleci.com/gh/happiness9721/line-bot-sdk-swift)
[![Swift 4.1](https://img.shields.io/badge/swift-4.1-brightgreen.svg)](https://swift.org)

SDK of the LINE Messaging API for Swift.

## About LINE Messaging API

See the official API documentation for more information.

English: https://devdocs.line.me/en/
Japanese: https://devdocs.line.me/ja/

## Installation

Add the dependency to Package.swift.

```swift
.package(url: "https://github.com/happiness9721/line-bot-sdk-swift.git", from: "2.0.0")
```

## Synopsis

I only provide Vapor example code since just testing on this framework.
If you use other framework, all you need is provide parameters of `signature: String` and `bodyContent: String`.
Feel free to send PR for providing other framework example. 🖖

Vapor 3:

```swift
router.post("callback") { (request) -> Future<HTTPStatus> in
  let bot = LineBot(accessToken: "ACCESS_TOKEN", channelSecret: "CHANNEL_SECRET")

  let content = request.http.body.description
  guard let signature = request.http.headers.firstValue(name: HTTPHeaderName("X-Line-Signature")) else {
    return .badRequest
  }
  guard linebot.validateSignature(content: content, signature: signature) else {
    return .badRequest
  }
  guard let events = linebot.parseEventsFrom(requestBody: content) else {
    return .badRequest
  }

  for event in events {
    switch event {
    case .message(let message):
      let replyToken = message.replyToken
      switch message.message {
      case .text(let content):
        bot.reply(token: replyToken, messages: [.text(text: content.text)])
      case _:
        break
      }
    case _:
      break
    }
  }

  return .ok
}
```