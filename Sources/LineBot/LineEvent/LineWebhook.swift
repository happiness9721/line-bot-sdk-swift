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
        try events.append(.message(.init(from: event)))
      case .follow:
        try events.append(.follow(.init(from: event)))
      case .unfollow:
        try events.append(.unfollow(.init(from: event)))
      case .join:
        try events.append(.join(.init(from: event)))
      case .leave:
        try events.append(.leave(.init(from: event)))
      case .postback:
        try events.append(.postback(.init(from: event)))
      case .beacon:
        try events.append(.beacon(.init(from: event)))
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

