//
//  LineBot.swift
//  LineBot
//
//  Created by happiness9721 on 2017/10/18.
//

import Foundation
import Cryptor

public final class LineBot {
  
  internal let accessToken: String
  internal let channelSecret: String

  private var client: HTTPClient {
    return HTTPClient()
  }

  public init(accessToken: String, channelSecret: String) {
    self.accessToken = accessToken
    self.channelSecret = channelSecret
  }

  public func receive(body: String, signature: String) -> LineWebhook? {
    guard validateSignature(body: body, signature: signature) else {
      return nil
    }
    guard let data = body.data(using: .utf8) else {
      return nil
    }
    return try? JSONDecoder().decode(LineWebhook.self, from: data)
  }

  public func send(by sender: LineSender, messages: [LineMessage]) {
    guard messages.count < 5 else {
      print("⚠️ Send failed. There are over 5 messages in array.")
      return
    }
    let map = messages.map{ $0.toDict() }
    sender.send(messages: map, accessToken: accessToken, client: client)
  }

  private func validateSignature(body: String, signature: String) -> Bool {
    guard let hmac = HMAC(using: .sha256, key: channelSecret).update(string: body)?.final() else {
      return false
    }
    let hmacData = Data(hmac)
    let hmacHex = hmacData.base64EncodedString(options: .endLineWithLineFeed)
    return hmacHex == signature
  }

}

