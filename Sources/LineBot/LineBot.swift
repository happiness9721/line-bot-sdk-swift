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
  internal let endPoint: String
  internal let session: URLSession

  public init(accessToken: String, channelSecret: String, endPoint: String? = nil) {
    self.accessToken = accessToken
    self.channelSecret = channelSecret
    self.endPoint = endPoint ?? "https://api.line.me/v2"
    self.session = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)
  }

  public func parseEventsFrom(requestBody: String) -> [LineEvent]? {
    guard let data = requestBody.data(using: .utf8) else {
      return nil
    }
    let webhook = try? JSONDecoder().decode(LineWebhook.self, from: data)
    return webhook?.events
  }

  public func validateSignature(content: String, signature: String) -> Bool {
    guard let hmac = HMAC(using: .sha256, key: channelSecret).update(string: content)?.final() else {
      return false
    }
    let hmacData = Data(hmac)
    let hmacHex = hmacData.base64EncodedString(options: .endLineWithLineFeed)
    return hmacHex == signature
  }

}

// Message
public extension LineBot {

  public func reply(token: String, messages: [LineMessage], completionHandler: ((Data?) -> ())? = nil) {
    let body: [String: Any] = [
      "replyToken": token,
      "messages": messages.map{ $0.toDict() }
    ]
    let request = makeRequest(method: "POST",
                              path: "/bot/message/reply",
                              body: body)
    session.sendRequest(request: request, completionHandler: completionHandler)
  }

  public func push(userId: String, messages: [LineMessage], completionHandler: ((Data?) -> ())? = nil) {
    let body: [String: Any] = [
      "to": userId,
      "messages": messages.map{ $0.toDict() }
    ]
    let request = makeRequest(method: "POST",
                              path: "/bot/message/push",
                              body: body)
    session.sendRequest(request: request, completionHandler: completionHandler)
  }

  public func multicast(to: [String], messages: [LineMessage], completionHandler: ((Data?) -> ())? = nil) {
    let body: [String: Any] = [
      "to": to,
      "messages": messages.map{ $0.toDict() }
    ]
    let request = makeRequest(method: "POST",
                              path: "/bot/message/multicast",
                              body: body)
    session.sendRequest(request: request, completionHandler: completionHandler)
  }

  public func getMessageContent(identifier: String, completionHandler: ((Data?) -> ())? = nil) {
    let request = makeRequest(method: "GET",
                              path: "/bot/message/\(identifier)/content")
    session.sendRequest(request: request, completionHandler: completionHandler)
  }

  private func makeRequest(method: String, path: String, body: [String: Any] = [:]) -> URLRequest {
    var request = URLRequest(url: URL(string: endPoint + path)!)

    request.httpMethod = method

    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    request.httpBody = try? JSONSerialization.data(withJSONObject: body,
                                                   options: .prettyPrinted)
    return request
  }

}

// Profile
public extension LineBot {

  public func getProfile(userId: String, completionHandler: ((Data?) -> ())? = nil) {
    let request = makeRequest(method: "GET",
                              path: "/bot/profile/\(userId)/content")
    session.sendRequest(request: request, completionHandler: completionHandler)
  }

}

// Group
public extension LineBot {

  public func getProfile(groupId: String, userId: String, completionHandler: ((Data?) -> ())? = nil) {
    let request = makeRequest(method: "GET",
                              path: "/bot/group/\(groupId)/member/\(userId)")
    session.sendRequest(request: request, completionHandler: completionHandler)
  }

  public func getMemberIds(groupId: String, continuationToken: String? = nil, completionHandler: ((Data?) -> ())? = nil) {
    var path = "/bot/group/\(groupId)/members/ids"
    if let continuationToken = continuationToken {
      path += "?start=\(continuationToken)"
    }
    let request = makeRequest(method: "GET", path: path)
    session.sendRequest(request: request, completionHandler: completionHandler)
  }

  public func leave(groupId: String, completionHandler: ((Data?) -> ())? = nil) {
    let request = makeRequest(method: "POST",
                              path: "/bot/group/\(groupId)/leave")
    session.sendRequest(request: request, completionHandler: completionHandler)
  }

}

// Room
public extension LineBot {

  public func getProfile(roomId: String, userId: String, completionHandler: ((Data?) -> ())? = nil) {
    let request = makeRequest(method: "GET",
                              path: "/bot/room/\(roomId)/member/\(userId)")
    session.sendRequest(request: request, completionHandler: completionHandler)
  }

  public func getMemberIds(roomId: String, continuationToken: String? = nil, completionHandler: ((Data?) -> ())? = nil) {
    var path = "/bot/room/\(roomId)/members/ids"
    if let continuationToken = continuationToken {
      path += "?start=\(continuationToken)"
    }
    let request = makeRequest(method: "GET", path: path)
    session.sendRequest(request: request, completionHandler: completionHandler)
  }

  public func leave(roomId: String, completionHandler: ((Data?) -> ())? = nil) {
    let request = makeRequest(method: "POST",
                              path: "/bot/room/\(roomId)/leave")
    session.sendRequest(request: request, completionHandler: completionHandler)
  }

}

fileprivate extension URLSession {

  fileprivate func sendRequest(request: URLRequest, completionHandler: ((Data?) -> ())? = nil) {
    let dataTask = self.dataTask(with: request) { data, response, error in
      completionHandler?(data)
    }
    dataTask.resume()
  }
  
}

