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

  fileprivate func makeRequest(method: String, path: String, body: [String: Any] = [:]) -> URLRequest {
    var request = URLRequest(url: URL(string: endPoint + path)!)

    request.httpMethod = method

    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    request.httpBody = try? JSONSerialization.data(withJSONObject: body,
                                                   options: .prettyPrinted)
    return request
  }

}

// Message
public extension LineBot {

  @available(*, deprecated, message: "Use reply(token:messages:onCompleted:onError:) instead")
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

  public func reply(token: String, messages: [LineMessage], onCompleted: (() -> ())? = nil, onError: ((Error) -> ())? = nil) {
    let body: [String: Any] = [
      "replyToken": token,
      "messages": messages.map{ $0.toDict() }
    ]
    let request = makeRequest(method: "POST",
                              path: "/bot/message/reply",
                              body: body)
    session.sendRequest(request: request, onCompleted: onCompleted, onError: onError)
  }

  public func reply(token: String, messages: [LineMessage]) {
    reply(token: token, messages: messages, onCompleted: nil, onError: nil)
  }

  @available(*, deprecated, message: "Use push(to:messages:onCompleted:onError:) instead")
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

  public func push(to: String, messages: [LineMessage], onCompleted: (() -> ())? = nil, onError: ((Error) -> ())? = nil) {
    let body: [String: Any] = [
      "to": to,
      "messages": messages.map{ $0.toDict() }
    ]
    let request = makeRequest(method: "POST",
                              path: "/bot/message/push",
                              body: body)
    session.sendRequest(request: request, onCompleted: onCompleted, onError: onError)
  }

  @available(*, deprecated, message: "Use multicast(to:messages:onCompleted:onError:) instead")
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

  public func multicast(to: [String], messages: [LineMessage], onCompleted: (() -> ())? = nil, onError: ((Error) -> ())? = nil) {
    let body: [String: Any] = [
      "to": to,
      "messages": messages.map{ $0.toDict() }
    ]
    let request = makeRequest(method: "POST",
                              path: "/bot/message/multicast",
                              body: body)
    session.sendRequest(request: request, onCompleted: onCompleted, onError: onError)
  }

  public func multicast(to: [String], messages: [LineMessage]) {
    multicast(to: to, messages: messages, onCompleted: nil, onError: nil)
  }

  @available(*, deprecated, message: "Use getMessageContent(identifier:onCompleted:onError:) instead")
  public func getMessageContent(identifier: String, completionHandler: ((Data?) -> ())? = nil) {
    let request = makeRequest(method: "GET",
                              path: "/bot/message/\(identifier)/content")
    session.sendRequest(request: request, completionHandler: completionHandler)
  }

  public func getMessageContent(identifier: String, onCompleted: ((Data?) -> ())? = nil, onError: ((Error) -> ())? = nil) {
    let request = makeRequest(method: "GET",
                              path: "/bot/message/\(identifier)/content")
    session.sendRequest(request: request, onCompleted: onCompleted, onError: onError)
  }

}

// Profile
public extension LineBot {

  @available(*, deprecated, message: "Use getProfile(userId:onCompleted:onError:) instead")
  public func getProfile(userId: String, completionHandler: ((Data?) -> ())? = nil) {
    let request = makeRequest(method: "GET",
                              path: "/bot/profile/\(userId)/content")
    session.sendRequest(request: request, completionHandler: completionHandler)
  }

  public func getProfile(userId: String, onCompleted: ((LineProfile) -> ())? = nil, onError: ((Error) -> ())? = nil) {
    let request = makeRequest(method: "GET",
                              path: "/bot/profile/\(userId)/content")
    session.sendRequest(request: request, onCompleted: onCompleted, onError: onError)
  }

}

// Group
public extension LineBot {

  @available(*, deprecated, message: "Use getProfile(groupId:userId:onCompleted:onError:) instead")
  public func getProfile(groupId: String, userId: String, completionHandler: ((Data?) -> ())? = nil) {
    let request = makeRequest(method: "GET",
                              path: "/bot/group/\(groupId)/member/\(userId)")
    session.sendRequest(request: request, completionHandler: completionHandler)
  }

  public func getProfile(groupId: String, userId: String, onCompleted: ((LineProfile) -> ())? = nil, onError: ((Error) -> ())? = nil) {
    let request = makeRequest(method: "GET",
                              path: "/bot/group/\(groupId)/member/\(userId)")
    session.sendRequest(request: request, onCompleted: onCompleted, onError: onError)
  }

  @available(*, deprecated, message: "Use getMemberIds(groupId:continuationToken:onCompleted:onError:) instead")
  public func getMemberIds(groupId: String, continuationToken: String? = nil, completionHandler: ((Data?) -> ())? = nil) {
    var path = "/bot/group/\(groupId)/members/ids"
    if let continuationToken = continuationToken {
      path += "?start=\(continuationToken)"
    }
    let request = makeRequest(method: "GET", path: path)
    session.sendRequest(request: request, completionHandler: completionHandler)
  }

  public func getMemberIds(groupId: String, continuationToken: String? = nil, onCompleted: ((LineMemberIds) -> ())? = nil, onError: ((Error) -> ())? = nil) {
    var path = "/bot/group/\(groupId)/members/ids"
    if let continuationToken = continuationToken {
      path += "?start=\(continuationToken)"
    }
    let request = makeRequest(method: "GET", path: path)
    session.sendRequest(request: request, onCompleted: onCompleted, onError: onError)
  }

  @available(*, deprecated, message: "Use leave(groupId:onCompleted:onError:) instead")
  public func leave(groupId: String, completionHandler: ((Data?) -> ())? = nil) {
    let request = makeRequest(method: "POST",
                              path: "/bot/group/\(groupId)/leave")
    session.sendRequest(request: request, completionHandler: completionHandler)
  }

  public func leave(groupId: String, onCompleted: (() -> ())? = nil, onError: ((Error) -> ())? = nil) {
    let request = makeRequest(method: "POST",
                              path: "/bot/group/\(groupId)/leave")
    session.sendRequest(request: request, onCompleted: onCompleted, onError: onError)
  }

  public func leave(groupId: String) {
    leave(groupId: groupId, onCompleted: nil, onError: nil)
  }

}

// Room
public extension LineBot {

  @available(*, deprecated, message: "Use getProfile(roomId:userId:onCompleted:onError:) instead")
  public func getProfile(roomId: String, userId: String, completionHandler: ((Data?) -> ())? = nil) {
    let request = makeRequest(method: "GET",
                              path: "/bot/room/\(roomId)/member/\(userId)")
    session.sendRequest(request: request, completionHandler: completionHandler)
  }

  public func getProfile(roomId: String, userId: String, onCompleted: ((LineProfile) -> ())? = nil, onError: ((Error) -> ())? = nil) {
    let request = makeRequest(method: "GET",
                              path: "/bot/room/\(roomId)/member/\(userId)")
    session.sendRequest(request: request, onCompleted: onCompleted, onError: onError)
  }

  @available(*, deprecated, message: "Use getMemberIds(roomId:continuationToken:onCompleted:onError:) instead")
  public func getMemberIds(roomId: String, continuationToken: String? = nil, completionHandler: ((Data?) -> ())? = nil) {
    var path = "/bot/room/\(roomId)/members/ids"
    if let continuationToken = continuationToken {
      path += "?start=\(continuationToken)"
    }
    let request = makeRequest(method: "GET", path: path)
    session.sendRequest(request: request, completionHandler: completionHandler)
  }

  public func getMemberIds(roomId: String, continuationToken: String? = nil, onCompleted: ((LineMemberIds) -> ())? = nil, onError: ((Error) -> ())? = nil) {
    var path = "/bot/room/\(roomId)/members/ids"
    if let continuationToken = continuationToken {
      path += "?start=\(continuationToken)"
    }
    let request = makeRequest(method: "GET", path: path)
    session.sendRequest(request: request, onCompleted: onCompleted, onError: onError)
  }

  @available(*, deprecated, message: "Use leave(roomId:onCompleted:onError:) instead")
  public func leave(roomId: String, completionHandler: ((Data?) -> ())? = nil) {
    let request = makeRequest(method: "POST",
                              path: "/bot/room/\(roomId)/leave")
    session.sendRequest(request: request, completionHandler: completionHandler)
  }

  public func leave(roomId: String, onCompleted: (() -> ())? = nil, onError: ((Error) -> ())? = nil) {
    let request = makeRequest(method: "POST",
                              path: "/bot/room/\(roomId)/leave")
    session.sendRequest(request: request, onCompleted: onCompleted, onError: onError)
  }

  public func leave(roomId: String) {
    leave(roomId: roomId, onCompleted: nil, onError: nil)
  }

}

fileprivate extension URLSession {

  @available(*, deprecated, message: "Use sendRequest(request:onCompleted:onError:) instead")
  fileprivate func sendRequest(request: URLRequest, completionHandler: ((Data?) -> ())? = nil) {
    let dataTask = self.dataTask(with: request) { data, response, error in
      completionHandler?(data)
    }
    dataTask.resume()
  }

  fileprivate func sendRequest<T: Decodable>(request: URLRequest, onCompleted: ((T) -> ())? = nil, onError: ((Error) -> ())? = nil) {
    let dataTask = self.dataTask(with: request) { data, response, error in
      guard error == nil else {
        onError?(error!)
        return
      }
      guard let response = response as? HTTPURLResponse,
            let data = data else {
        return
      }
      guard response.statusCode == 200 else {
        if let error = try? LineError(statusCode: response.statusCode, content: JSONDecoder().decode(LineError.Content.self, from: data)) {
          onError?(error)
        }
        return
      }
      try? onCompleted?(JSONDecoder().decode(T.self, from: data))
    }
    dataTask.resume()
  }

  fileprivate func sendRequest(request: URLRequest, onCompleted: (() -> ())? = nil, onError: ((Error) -> ())? = nil) {
    let dataTask = self.dataTask(with: request) { data, response, error in
      guard error == nil else {
        onError?(error!)
        return
      }
      guard let response = response as? HTTPURLResponse else {
        return
      }
      guard response.statusCode == 200 else {
        if let data = data,
          let error = try? LineError(statusCode: response.statusCode, content: JSONDecoder().decode(LineError.Content.self, from: data)) {
          onError?(error)
        }
        return
      }
      onCompleted?()
    }
    dataTask.resume()
  }
  
}

