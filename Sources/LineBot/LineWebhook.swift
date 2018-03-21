//
//  LineWebhook.swift
//  LineBot
//
//  Created by happiness9721 on 2018/3/17.
//

import Foundation

internal struct DataKey: CodingKey {
  var stringValue: String
  init(stringValue: String) {
    self.stringValue = stringValue
  }
  var intValue: Int? {return nil}
  init?(intValue: Int) {return nil}
}

public struct LineWebhook: Decodable {

  public let events: [LineWebhookEvent]

  public init(from decoder: Decoder) throws {
    var events = [LineWebhookEvent]()
    let container = try decoder.container(keyedBy: DataKey.self)
    var unkeyedContainer = try container.nestedUnkeyedContainer(forKey: DataKey(stringValue: "events"))
    while !unkeyedContainer.isAtEnd {
      let event = try unkeyedContainer.nestedContainer(keyedBy: DataKey.self)
      let type = try event.decode(EventType.self, forKey: DataKey(stringValue: "type"))
      switch type {
      case .message:
        try events.append(LineWebhookEvent.message(LineWebhookEventBase.Message(from: event)))
      case .follow:
        try events.append(LineWebhookEvent.follow(LineWebhookEventBase.Follow(from: event)))
      case .unfollow:
        try events.append(LineWebhookEvent.unfollow(LineWebhookEventBase.Unfollow(from: event)))
      case .join:
        try events.append(LineWebhookEvent.join(LineWebhookEventBase.Join(from: event)))
      case .leave:
        try events.append(LineWebhookEvent.leave(LineWebhookEventBase.Leave(from: event)))
      case .postback:
        try events.append(LineWebhookEvent.postback(LineWebhookEventBase.Postback(from: event)))
      case .beacon:
        try events.append(LineWebhookEvent.beacon(LineWebhookEventBase.Beacon(from: event)))
      }
    }
    self.events = events
  }

  private enum EventType: String, Codable {

    case message = "message"
    case follow = "follow"
    case unfollow = "unfollow"
    case join = "join"
    case leave = "leave"
    case postback = "postback"
    case beacon = "beacon"

  }
}

