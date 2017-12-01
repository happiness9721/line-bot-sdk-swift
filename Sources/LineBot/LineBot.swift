//
//  LineBot.swift
//  LineBotPackageDescription
//
//  Created by happiness9721 on 2017/10/18.
//

import Foundation
import Crypto
import Vapor

public final class LineBot {

  public var source: Node?
  public var receivedMessage: String?

  private static var accessToken = ""
  private static var channelSecret = ""
  private let replyEndpoint = "https://api.line.me/v2/bot/message/reply"
  private let pushEndpoint = "https://api.line.me/v2/bot/message/push"
  private let method = "POST"
  private let replyToken: String?
  private let pushTo: [String]?
  private var messages = [[String: Any]]()

  private var client: HTTPClient {
    return HTTPClient()
  }

  private init(pushTo: [String]? = nil, replyToken: String? = nil) {
    self.pushTo = pushTo
    self.replyToken = replyToken
  }

  public static func makeReply(from request: Request) -> LineBot? {
    guard let jsonBody = request.body.bytes?.makeString() else {
      return nil
    }

    guard let signature = request.headers["X-Line-Signature"] else {
      return nil
    }

    guard let object = request.data["events"]?.array?.first?.object else {
      return nil
    }

    guard let message = object["message"]?.object?["text"]?.string else {
      return nil
    }

    guard let replyToken = object["replyToken"]?.string else {
      return nil
    }

    guard let source = object["source"] else {
      return nil
    }

    print(jsonBody)

    if validateSignature(message: jsonBody, signature: signature) {
      let lineBot = LineBot(replyToken: replyToken)
      lineBot.source = source
      lineBot.receivedMessage = message
      return lineBot
    } else {
      return nil
    }
  }

  public static func makePush(to: [String]) -> LineBot {
    let lineBot = LineBot(pushTo: to)
    return lineBot
  }

  public static func configure(accessToken: String, channelSecret: String) {
    self.accessToken = accessToken
    self.channelSecret = channelSecret
  }

  public func add(message: LineMessage) {
    if messages.count < 5 {
      messages.append(message.toDict())
    } else {
      print("⚠️ There are 5 messages in array, this message haven't been added.")
    }
  }

  private static func validateSignature(message: String, signature: String) -> Bool {
    do {
      let hash = try HMAC.make(.sha256,
                               message.makeBytes(),
                               key: LineBot.channelSecret.makeBytes())
      print(signature)
      print(hash.base64Encoded.hexString)
      return hash.base64Encoded.hexString == signature
    } catch {
      return false
    }
  }

  public func sendReply() -> Response {
    if let replyToken = replyToken, messages.count > 0 {
      var request = URLRequest(url: URL(string: replyEndpoint)!)

      request.httpMethod = method

      request.addValue("application/json", forHTTPHeaderField: "Content-Type")
      request.addValue("Bearer \(LineBot.accessToken)", forHTTPHeaderField: "Authorization")

      let body: [String: Any] = [
        "replyToken": replyToken,
        "messages": messages
      ]

      request.httpBody = try? JSONSerialization.data(withJSONObject: body,
                                                     options: .prettyPrinted)

      client.sendRequest(request: request)
    }
    return Response(status: .ok, body: "reply")
  }

  public func sendPush() -> Response {
    if let pushTo = pushTo, messages.count > 0 {
      var request = URLRequest(url: URL(string: pushEndpoint)!)

      request.httpMethod = method

      request.addValue("application/json", forHTTPHeaderField: "Content-Type")
      request.addValue("Bearer \(LineBot.accessToken)", forHTTPHeaderField: "Authorization")

      for to in pushTo {
        let body: [String: Any] = [
          "to": to,
          "messages": messages
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body,
                                                       options: .prettyPrinted)

        client.sendRequest(request: request)
      }
    }
    return Response(status: .ok, body: "reply")
  }

}

