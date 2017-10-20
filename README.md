Swift SDK for the LINE Messaging API with Vapor


## About LINE Messaging API

See the official API documentation for more information.

English: https://devdocs.line.me/en/<br>
Japanese: https://devdocs.line.me/ja/

## Setup
Add the dependency to Package.swift.
Note that the syntax is different for Swift 3 and 4.

Swift 3:
```swift
.Package(url: "https://github.com/happiness9721/line-bot-sdk-swift.git", majorVersion: 1, minor: 0)
```

Swift 4:
```swift
.package(url: "https://github.com/happiness9721/line-bot-sdk-swift.git", .upToNextMajor(from: "1.0.0"))
```

## Configuration

1. put this in your `Droplet+Setup.swift`, inside of Droplet's setup() 

```swift
// Channel Access Token
guard let accessToken = config["line_config", "access_token"]?.string else {
  fatalError("error, put line_config.json into Config/secrets and write access_token")
}
LineBot.configure(with: accessToken)
```

2. Create `Config/line_config.json` and set your `ChannelAccessToken` as enviroment variable
```json
{
  "access_token": "$ChannelAccessToken:NoToken"
}
```

## How to start

Put below code in your Routes.swift or your own Controller.

```swift
guard let object = req.data["events"]?.array?.first?.object else {
    return Response(status: .ok, body: "this message is not supported")
}

guard let message = object["message"]?.object?["text"]?.string else {
    return Response(status: .ok, body: "this message is not supported")
}

guard let replyToken = object["replyToken"]?.string else {
    return Response(status: .ok, body: "this message is not supported")
}

guard let source = object["source"] else {
    return Response(status: .ok, body: "this message is not supported")
}

let lineBot = LineBot(replyToken: replyToken)
lineBot.add(message: message)
lineBot.send()
return Response(status: .ok, body: "reply")
```

## 🎉 That's all! 🎉

## LICENSE

LineBot is released under the MIT license. See LICENSE for details.
