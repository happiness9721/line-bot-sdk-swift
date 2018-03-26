//
//  LineEvent.swift
//  LineBot
//
//  Created by happiness9721 on 2018/3/20.
//

import Foundation

public enum LineEvent {

  case message(_: LineEventBase.MessageEvent)
  case follow(_: LineEventBase.FollowEvent)
  case unfollow(_: LineEventBase.UnfollowEvent)
  case join(_: LineEventBase.JoinEvent)
  case leave(_: LineEventBase.LeaveEvent)
  case postback(_: LineEventBase.PostbackEvent)
  case beacon(_: LineEventBase.BeaconEvent)

}

public class LineEventBase {

  public let timestamp: Double
  public let source: Source

  internal init(from container: KeyedDecodingContainer<DataKey>) throws {
    timestamp = try container.decode(Double.self, forKey: DataKey(stringValue: "timestamp"))
    source = try container.decode(Source.self, forKey: DataKey(stringValue: "source"))
  }

  public class MessageEvent: LineEventBase {

    public let replyToken: String
    public let message: LineEventMessage

    internal override init(from container: KeyedDecodingContainer<DataKey>) throws {
      message = try container.decode(LineEventMessage.self, forKey: DataKey(stringValue: "message"))
      replyToken = try container.decode(String.self, forKey: DataKey(stringValue: "replyToken"))
      try super.init(from: container)
    }

  }

  public class FollowEvent: LineEventBase {

    public let replyToken: String

    internal override init(from container: KeyedDecodingContainer<DataKey>) throws {
      replyToken = try container.decode(String.self, forKey: DataKey(stringValue: "replyToken"))
      try super.init(from: container)
    }

  }

  public class UnfollowEvent: LineEventBase {

  }

  public class JoinEvent: LineEventBase {

    public let replyToken: String

    internal override init(from container: KeyedDecodingContainer<DataKey>) throws {
      replyToken = try container.decode(String.self, forKey: DataKey(stringValue: "replyToken"))
      try super.init(from: container)
    }

  }

  public class LeaveEvent: LineEventBase {

  }

  public class PostbackEvent: LineEventBase {

    public let replyToken: String
    public let postback: Postback

    internal override init(from container: KeyedDecodingContainer<DataKey>) throws {
      replyToken = try container.decode(String.self, forKey: DataKey(stringValue: "replyToken"))
      postback = try container.decode(Postback.self, forKey: DataKey(stringValue: "postback"))
      try super.init(from: container)
    }

    public struct Postback: Codable {

      public let data: String
      public let params: LineWebhookPostbackParams?

    }

    public struct LineWebhookPostbackParams: Codable {

      public let date: String?
      public let time: String?
      public let datetime: String?

    }

  }

  public class BeaconEvent: LineEventBase {

    public let replyToken: String
    public let hwid: String
    public let type: LineWebhookBeaconType
    public let dm: String

    internal override init(from container: KeyedDecodingContainer<DataKey>) throws {
      replyToken = try container.decode(String.self, forKey: DataKey(stringValue: "replyToken"))
      hwid = try container.decode(String.self, forKey: DataKey(stringValue: "hwid"))
      type = try container.decode(LineWebhookBeaconType.self, forKey: DataKey(stringValue: "type"))
      dm = try container.decode(String.self, forKey: DataKey(stringValue: "dm"))
      try super.init(from: container)
    }

    public enum LineWebhookBeaconType: String, Codable {

      case enter = "enter"
      case leave = "leave"
      case banner = "banner"

    }

  }

  public struct Source: Codable {

    public let type: SourceType
    public let userId: String
    public let groupId: String?
    public let roomId: String?

  }

  public enum SourceType: String, Codable {

    case user = "user"
    case group = "group"
    case room = "room"

  }

}
