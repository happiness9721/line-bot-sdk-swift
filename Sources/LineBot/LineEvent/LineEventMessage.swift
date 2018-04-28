//
//  LineEventMessage.swift
//  LineBot
//
//  Created by happiness9721 on 2018/3/19.
//

import Foundation

public enum LineEventMessage: Decodable {

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: TypeKey.self)
    let type = try container.decode(MessageType.self, forKey: .type)
    switch type {
    case .text:
      self = try .text(.init(from: decoder))
    case .image:
      self = try .image(.init(from: decoder))
    case .video:
      self = try .video(.init(from: decoder))
    case .audio:
      self = try .audio(.init(from: decoder))
    case .file:
      self = try .file(.init(from: decoder))
    case .location:
      self = try .location(.init(from: decoder))
    case .sticker:
      self = try .sticker(.init(from: decoder))
    }
  }

  case text(_: Text)
  case image(_: Content)
  case video(_: Content)
  case audio(_: Content)
  case file(_: File)
  case location(_: Location)
  case sticker(_: Sticker)

  public struct Text: Codable {

    public let id: String
    public let text: String

  }

  public struct Content: Codable {

    public let id: String

  }

  public struct File: Codable {

    public let id: String
    public let fileName: String
    public let fileSize: String

  }

  public struct Location: Codable {

    public let id: String
    public let title: String?
    public let address: String?
    public let latitude: Double?
    public let longitude: Double?

  }

  public struct Sticker: Codable {

    public let id: String
    public let packageId: String?
    public let stickerId: String?

  }

  private enum TypeKey: String, CodingKey {

    case type = "type"

  }

  private enum MessageType: String, Codable {

    case text = "text"
    case image = "image"
    case video = "video"
    case audio = "audio"
    case file = "file"
    case location = "location"
    case sticker = "sticker"

  }

}

