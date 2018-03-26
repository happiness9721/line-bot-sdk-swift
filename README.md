SDK of the LINE Messaging API for Swift.


## About LINE Messaging API

See the official API documentation for more information.

English: https://devdocs.line.me/en/<br>
Japanese: https://devdocs.line.me/ja/

## Installation

Add the dependency to Package.swift.

```swift
.package(url: "https://github.com/happiness9721/line-bot-sdk-swift.git", .upToNextMajor(from: "2.0.0"))
```

## Synopsis

I only provide Vapor example code since just testing on this framework.<br>
If you use other framework, all you need is provide parameters of `signature: String` and `bodyContent: String`.<br>
Feel free to send PR for providing other framework example. 🖖

Vapor:

```swift
post("callback") { request in
  let bot = LineBot(accessToken: "ACCESS_TOKEN", channelSecret: "CHANNEL_SECRET")

  guard let content = request.body.bytes?.makeString() else {
    return Response(status: .badRequest)
  }

  guard let signature = request.headers["X-Line-Signature"] else {
    return Response(status: .badRequest)
  }

  guard bot.validateSignature(content: content, signature: signature) else {
    return Response(status: .badRequest)
  }

  guard let events = bot.parseEventsFrom(requestBody: content) else {
    return Response(status: .badRequest)
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

  return Response(status: .ok)
}
```

## LICENSE

LineBot is released under the MIT license. See LICENSE for details.
