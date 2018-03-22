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

  public func parseEventsFrom(requestBody: String) -> [LineWebhookEvent]? {
    guard let data = requestBody.data(using: .utf8) else {
      return nil
    }
    return try? JSONDecoder().decode(LineWebhook.self, from: data).events
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
    guard 1...5 ~= messages.count else {
      print("⚠️ Reply failed. Messages number invalid.")
      return
    }
    let body: [String: Any] = [
      "replyToken": token,
      "messages": messages.map{ $0.toDict() }
    ]
    let request = makeRequest(method: "POST",
                              path: "/bot/message/reply",
                              body: body)
    session.sendRequest(request: request, completionHandler: completionHandler)
  }

  public func push(userID: String, messages: [LineMessage], completionHandler: ((Data?) -> ())? = nil) {
    guard 1...5 ~= messages.count else {
      print("⚠️ Push failed. Messages number invalid.")
      return
    }
    let body: [String: Any] = [
      "to": userID,
      "messages": messages.map{ $0.toDict() }
    ]
    let request = makeRequest(method: "POST",
                              path: "/bot/message/push",
                              body: body)
    session.sendRequest(request: request, completionHandler: completionHandler)
  }

  public func multicast(to: [String], messages: [LineMessage], completionHandler: ((Data?) -> ())? = nil) {
    guard 1...5 ~= messages.count else {
      print("⚠️ Push failed. Messages number invalid.")
      return
    }
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

  public func getProfile(userID: String, completionHandler: ((Data?) -> ())? = nil) {
    let request = makeRequest(method: "GET",
                              path: "/bot/profile/\(userID)/content")
    session.sendRequest(request: request, completionHandler: completionHandler)
  }

}

// Group
public extension LineBot {

  public func getProfile(groupID: String, userID: String, completionHandler: ((Data?) -> ())? = nil) {
    let request = makeRequest(method: "GET",
                              path: "/bot/group/\(groupID)/member/\(userID)")
    session.sendRequest(request: request, completionHandler: completionHandler)
  }

  public func getMemberIDs(groupID: String, continuationToken: String? = nil, completionHandler: ((Data?) -> ())? = nil) {
    var path = "/bot/group/\(groupID)/members/ids"
    if let continuationToken = continuationToken {
      path += "?start=\(continuationToken)"
    }
    let request = makeRequest(method: "GET", path: path)
    session.sendRequest(request: request, completionHandler: completionHandler)
  }

  public func leave(groupID: String, completionHandler: ((Data?) -> ())? = nil) {
    let request = makeRequest(method: "POST",
                              path: "/bot/group/\(groupID)/leave")
    session.sendRequest(request: request, completionHandler: completionHandler)
  }

}

// Room
public extension LineBot {

  public func getProfile(roomID: String, userID: String, completionHandler: ((Data?) -> ())? = nil) {
    let request = makeRequest(method: "GET",
                              path: "/bot/room/\(roomID)/member/\(userID)")
    session.sendRequest(request: request, completionHandler: completionHandler)
  }

  public func getMemberIDs(roomID: String, continuationToken: String? = nil, completionHandler: ((Data?) -> ())? = nil) {
    var path = "/bot/room/\(roomID)/members/ids"
    if let continuationToken = continuationToken {
      path += "?start=\(continuationToken)"
    }
    let request = makeRequest(method: "GET", path: path)
    session.sendRequest(request: request, completionHandler: completionHandler)
  }

  public func leave(roomID: String, completionHandler: ((Data?) -> ())? = nil) {
    let request = makeRequest(method: "POST",
                              path: "/bot/room/\(roomID)/leave")
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

