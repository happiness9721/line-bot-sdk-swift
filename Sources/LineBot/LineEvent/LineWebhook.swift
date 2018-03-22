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

internal struct LineWebhook: Decodable {

  internal let events: [LineEvent]

  internal init(from decoder: Decoder) throws {
    var events = [LineEvent]()
    let container = try decoder.container(keyedBy: DataKey.self)
    var unkeyedContainer = try container.nestedUnkeyedContainer(forKey: DataKey(stringValue: "events"))
    while !unkeyedContainer.isAtEnd {
      let event = try unkeyedContainer.nestedContainer(keyedBy: DataKey.self)
      let type = try event.decode(EventType.self, forKey: DataKey(stringValue: "type"))
      switch type {
      case .message:
        try events.append(LineEvent.message(LineEventBase.Message(from: event)))
      case .follow:
        try events.append(LineEvent.follow(LineEventBase.Follow(from: event)))
      case .unfollow:
        try events.append(LineEvent.unfollow(LineEventBase.Unfollow(from: event)))
      case .join:
        try events.append(LineEvent.join(LineEventBase.Join(from: event)))
      case .leave:
        try events.append(LineEvent.leave(LineEventBase.Leave(from: event)))
      case .postback:
        try events.append(LineEvent.postback(LineEventBase.Postback(from: event)))
      case .beacon:
        try events.append(LineEvent.beacon(LineEventBase.Beacon(from: event)))
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

