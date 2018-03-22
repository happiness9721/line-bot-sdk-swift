//
//  LineEvent.swift
//  LineBot
//
//  Created by happiness9721 on 2018/3/20.
//

import Foundation

public enum LineEvent {

  case message(_: LineEventBase.Message)
  case follow(_: LineEventBase.Follow)
  case unfollow(_: LineEventBase.Unfollow)
  case join(_: LineEventBase.Join)
  case leave(_: LineEventBase.Leave)
  case postback(_: LineEventBase.Postback)
  case beacon(_: LineEventBase.Beacon)

}

public class LineEventBase {

  public let timestamp: Double
  public let source: Source

  internal init(from container: KeyedDecodingContainer<DataKey>) throws {
    timestamp = try container.decode(Double.self, forKey: DataKey(stringValue: "timestamp"))
    source = try container.decode(Source.self, forKey: DataKey(stringValue: "source"))
  }

  public class Message: LineEventBase {

    public let message: LineEventMessage
    public let replyToken: String

    internal override init(from container: KeyedDecodingContainer<DataKey>) throws {
      message = try container.decode(LineEventMessage.self, forKey: DataKey(stringValue: "message"))
      replyToken = try container.decode(String.self, forKey: DataKey(stringValue: "replyToken"))
      try super.init(from: container)
    }

  }

  public class Follow: LineEventBase {

    public let replyToken: String

    internal override init(from container: KeyedDecodingContainer<DataKey>) throws {
      replyToken = try container.decode(String.self, forKey: DataKey(stringValue: "replyToken"))
      try super.init(from: container)
    }

  }

  public class Unfollow: LineEventBase {

  }

  public class Join: LineEventBase {

    public let replyToken: String

    internal override init(from container: KeyedDecodingContainer<DataKey>) throws {
      replyToken = try container.decode(String.self, forKey: DataKey(stringValue: "replyToken"))
      try super.init(from: container)
    }

  }

  public class Leave: LineEventBase {

  }

  public class Postback: LineEventBase {

    public let replyToken: String
    public let data: String
    public let params: LineWebhookPostbackParams?

    internal override init(from container: KeyedDecodingContainer<DataKey>) throws {
      replyToken = try container.decode(String.self, forKey: DataKey(stringValue: "replyToken"))
      data = try container.decode(String.self, forKey: DataKey(stringValue: "data"))
      params = try container.decode(LineWebhookPostbackParams.self, forKey: DataKey(stringValue: "params"))
      try super.init(from: container)
    }

    public struct LineWebhookPostbackParams: Codable {

      public let date: String
      public let time: String
      public let datetime: String

    }

  }

  public class Beacon: LineEventBase {

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
