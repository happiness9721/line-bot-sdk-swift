//
//  LineBot.swift
//  LineBotPackageDescription
//
//  Created by happiness9721 on 2017/10/18.
//

import Foundation

public class LineBot {

  private var client: HTTPClient {
    return HTTPClient()
  }

  private static var accessToken = ""
  private let endpoint = "https://api.line.me/v2/bot/message/reply"
  private let method = "POST"
  private let replyToken: String
  private var messages = [[String: String]]()
  public var body: [String : Any]? {
    if messages.count > 0 {
      let payload: [String: Any] = [
        "replyToken": replyToken,
        "messages": messages
      ]
      return payload
    } else {
      return nil
    }
  }

  public init(replyToken: String) {
    self.replyToken = replyToken
  }

  public class func configure(with accessToken: String) {
    self.accessToken = accessToken
  }

  public func add(message: String) {
    if messages.count < 5 {
      messages.append(["type": "text",
                       "text": message])
    }
  }

  public func add(image: String) {
    if messages.count < 5 {
      messages.append(["type": "image",
                       "originalContentUrl": image,
                       "previewImageUrl": image])
    }
  }

  public func add(originalContentUrl: String, previewImageUrl: String) {
    if messages.count < 5 {
      messages.append(["type": "image",
                       "originalContentUrl": originalContentUrl,
                       "previewImageUrl": previewImageUrl])
    }
  }

  public func send() {
    if let body = body {
      var request = URLRequest(url: URL(string: endpoint)!)

      request.httpMethod = method

      request.addValue("application/json", forHTTPHeaderField: "Content-Type")
      request.addValue("Bearer \(LineBot.accessToken)", forHTTPHeaderField: "Authorization")

      request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)

      client.sendRequest(request: request)
    }
  }

}

