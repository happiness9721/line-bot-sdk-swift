//
//  LineWebhookEvent.swift
//  LineBot
//
//  Created by happiness9721 on 2018/3/20.
//

import Foundation

public enum LineWebhookEvent {

  case message(_: LineWebhookEventBase.Message)
  case follow(_: LineWebhookEventBase.Follow)
  case unfollow(_: LineWebhookEventBase.Unfollow)
  case join(_: LineWebhookEventBase.Join)
  case leave(_: LineWebhookEventBase.Leave)
  case postback(_: LineWebhookEventBase.Postback)
  case beacon(_: LineWebhookEventBase.Beacon)

}

public class LineWebhookEventBase {

  public let timestamp: Double
  public let source: Source

  internal init(from container: KeyedDecodingContainer<DataKey>) throws {
    timestamp = try container.decode(Double.self, forKey: DataKey(stringValue: "timestamp"))
    source = try container.decode(Source.self, forKey: DataKey(stringValue: "source"))
  }

  public class Message: LineWebhookEventBase {

    public let message: LineWebhookMessage
    public let replyToken: String

    internal override init(from container: KeyedDecodingContainer<DataKey>) throws {
      message = try container.decode(LineWebhookMessage.self, forKey: DataKey(stringValue: "message"))
      replyToken = try container.decode(String.self, forKey: DataKey(stringValue: "replyToken"))
      try super.init(from: container)
    }

  }

  public class Follow: LineWebhookEventBase {

    public let replyToken: String

    internal override init(from container: KeyedDecodingContainer<DataKey>) throws {
      replyToken = try container.decode(String.self, forKey: DataKey(stringValue: "replyToken"))
      try super.init(from: container)
    }

  }

  public class Unfollow: LineWebhookEventBase {

  }

  public class Join: LineWebhookEventBase {

    public let replyToken: String

    internal override init(from container: KeyedDecodingContainer<DataKey>) throws {
      replyToken = try container.decode(String.self, forKey: DataKey(stringValue: "replyToken"))
      try super.init(from: container)
    }

  }

  public class Leave: LineWebhookEventBase {

  }

  public class Postback: LineWebhookEventBase {

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

  public class Beacon: LineWebhookEventBase {

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

    let type: SourceType
    let userId: String
    let groupId: String?
    let roomId: String?

  }

  public enum SourceType: String, Codable {

    case user = "user"
    case group = "group"
    case room = "room"

  }

}
