//
//  LineBot.swift
//  LineBot
//
//  Created by happiness9721 on 2017/10/18.
//

import Foundation
import Cryptor

public final class LineBot {
  public enum MessageType {
    case reply(token: String)
    case push(to: [String])

    private var endPoint: String {
      switch self {
      case .reply:
        return "https://api.line.me/v2/bot/message/reply"
      case .push:
        return "https://api.line.me/v2/bot/message/push"
      }
    }

    private var method: String {
      return "POST"
    }

    private func request(body: [String: Any]) -> URLRequest {
      var request = URLRequest(url: URL(string: endPoint)!)

      request.httpMethod = method

      request.addValue("application/json", forHTTPHeaderField: "Content-Type")
      request.addValue("Bearer \(LineBot.accessToken)", forHTTPHeaderField: "Authorization")
      request.httpBody = try? JSONSerialization.data(withJSONObject: body,
                                                     options: .prettyPrinted)
      return request
    }

    fileprivate func send(messages: [[String: Any]], with client: HTTPClient) {
      switch self {
      case .reply(let token):
        guard messages.count > 0 else {
          print("⚠️ There are no message in queue, this reply cannot be sent.")
          return
        }
        let body: [String: Any] = [
          "replyToken": token,
          "messages": messages
        ]
        client.sendRequest(request: request(body: body))
      case .push(let pushTo):
        guard messages.count > 0 else {
          print("⚠️ There are no message in queue, this push cannot be sent.")
          return
        }
        for to in pushTo {
          let body: [String: Any] = [
            "to": to,
            "messages": messages
          ]
          client.sendRequest(request: request(body: body))
        }
      }
    }
  }

  private static var accessToken = ""
  private static var channelSecret = ""
  private let messageType: MessageType
  private var messages = [[String: Any]]()

  private var client: HTTPClient {
    return HTTPClient()
  }

  public init(messageType: MessageType) {
    self.messageType = messageType
  }

  public func send() {
    messageType.send(messages: messages, with: client)
  }

  public static func validateSignature(body: String, signature: String) -> Bool {
    guard let hmac = HMAC(using: .sha256, key: LineBot.channelSecret).update(string: body)?.final() else {
      return false
    }
    let hmacData = Data(hmac)
    let hmacHex = hmacData.base64EncodedString(options: .endLineWithLineFeed)
    return hmacHex == signature
  }

  public static func configure(accessToken: String, channelSecret: String) {
    self.accessToken = accessToken
    self.channelSecret = channelSecret
  }

  public func add(message: LineMessage) {
    guard messages.count < 5 else {
      print("⚠️ There are already 5 messages in queue, this message cannot be added.")
      return
    }
    messages.append(message.toDict())
  }

}

