//
//  LineMessage.swift
//  LineBot
//
//  Created by happiness9721 on 2017/12/1.
//

import Foundation

public protocol LineMessage {
  func toDict() -> [String: Any]
}

public class LineMessageText: LineMessage {

  public var text: String

  public init(text: String) {
    self.text = text
  }

  public func toDict() -> [String : Any] {
    return ["type": "text",
            "text": text]
  }

}

public class LineMessageSticker: LineMessage {

  public var packageId: String
  public var stickerId: String

  public init(packageId: String, stickerId: String) {
    self.packageId = packageId
    self.stickerId = stickerId
  }

  public func toDict() -> [String : Any] {
    return ["type": "sticker",
            "packageId": packageId,
            "stickerId": stickerId]
  }

}

public class LineMessageImage: LineMessage {

  public var originalContentUrl: String
  public var previewImageUrl: String

  public init(originalContentUrl: String, previewImageUrl: String) {
    self.originalContentUrl = originalContentUrl
    self.previewImageUrl = previewImageUrl
  }

  public func toDict() -> [String : Any] {
    return ["type": "image",
            "originalContentUrl": originalContentUrl,
            "originalContentUrl": previewImageUrl]
  }

}

public class LineMessageVideo: LineMessage {

  public var originalContentUrl: String
  public var previewImageUrl: String

  public init(originalContentUrl: String, previewImageUrl: String) {
    self.originalContentUrl = originalContentUrl
    self.previewImageUrl = previewImageUrl
  }

  public func toDict() -> [String : Any] {
    return ["type": "video",
            "originalContentUrl": originalContentUrl,
            "originalContentUrl": previewImageUrl]
  }

}

public class LineMessageAudio: LineMessage {

  public var originalContentUrl: String
  public var duration: Int

  public init(originalContentUrl: String, duration: Int) {
    self.originalContentUrl = originalContentUrl
    self.duration = duration
  }

  public func toDict() -> [String : Any] {
    return ["type": "video",
            "originalContentUrl": originalContentUrl,
            "duration": duration]
  }

}

public class LineMessageLocation: LineMessage {

  public var title: String
  public var address: String
  public var latitude: Double
  public var longitude: Double

  public init(title: String, address: String, latitude: Double, longitude: Double) {
    self.title = title
    self.address = address
    self.latitude = latitude
    self.longitude = longitude
  }

  public func toDict() -> [String : Any] {
    return ["type": "location",
            "title": title,
            "address": address,
            "latitude": latitude,
            "longitude": longitude]
  }
  
}

