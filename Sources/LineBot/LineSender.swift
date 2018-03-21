//
//  LineSender.swift
//  LineBot
//
//  Created by happiness9721 on 2018/3/17.
//

import Foundation

public enum LineSender {

  case reply(token: String)
  case push(to: [String])
  case multicast(to: [String])

}

extension LineSender {

  private var endPoint: String {
    switch self {
    case .reply:
      return "https://api.line.me/v2/bot/message/reply"
    case .push:
      return "https://api.line.me/v2/bot/message/push"
    case .multicast:
      return "https://api.line.me/v2/bot/message/multicast"
    }
  }

  private var method: String {
    return "POST"
  }

  private func request(body: [String: Any], accessToken: String) -> URLRequest {
    var request = URLRequest(url: URL(string: endPoint)!)

    request.httpMethod = method

    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    request.httpBody = try? JSONSerialization.data(withJSONObject: body,
                                                   options: .prettyPrinted)
    return request
  }

  internal func send(messages: [[String: Any]], accessToken: String, client: HTTPClient) {
    guard messages.count > 0 else {
      print("⚠️ There are no message in queue. Send failed.")
      return
    }
    switch self {
    case .reply(let token):
      let body: [String: Any] = [
        "replyToken": token,
        "messages": messages
      ]
      client.sendRequest(request: request(body: body, accessToken: accessToken))
    case .push(let pushTo):
      for to in pushTo {
        let body: [String: Any] = [
          "to": to,
          "messages": messages
        ]
        client.sendRequest(request: request(body: body, accessToken: accessToken))
      }
    case .multicast(let castTo):
      for to in castTo {
        let body: [String: Any] = [
          "to": to,
          "messages": messages
        ]
        client.sendRequest(request: request(body: body, accessToken: accessToken))
      }
    }
  }

}
