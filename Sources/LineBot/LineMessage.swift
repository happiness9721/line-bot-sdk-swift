//
//  LineMessage.swift
//  LineBot
//
//  Created by happiness9721 on 2017/12/1.
//

import Foundation
import CoreLocation

public protocol LineMessage {
  func toDict() -> [String: Any]
}

public struct LineMessageText: LineMessage {

  public var text: String

  public func toDict() -> [String : Any] {
    return ["type": "text",
            "text": text]
  }

}

public struct LineMessageSticker: LineMessage {

  public var packageId: String
  public var stickerId: String

  public func toDict() -> [String : Any] {
    return ["type": "sticker",
            "packageId": packageId,
            "stickerId": stickerId]
  }

}

public struct LineMessageImage: LineMessage {

  public var originalContentUrl: String
  public var previewImageUrl: String

  public func toDict() -> [String : Any] {
    return ["type": "image",
            "originalContentUrl": originalContentUrl,
            "originalContentUrl": previewImageUrl]
  }

}

public struct LineMessageVideo: LineMessage {

  public var originalContentUrl: String
  public var previewImageUrl: String

  public func toDict() -> [String : Any] {
    return ["type": "video",
            "originalContentUrl": originalContentUrl,
            "originalContentUrl": previewImageUrl]
  }

}

public struct LineMessageAudio: LineMessage {

  public var originalContentUrl: String
  public var duration: Int

  public func toDict() -> [String : Any] {
    return ["type": "video",
            "originalContentUrl": originalContentUrl,
            "duration": duration]
  }

}

public struct LineMessageLocation: LineMessage {

  public var title: String
  public var address: String
  public var location: CLLocationCoordinate2D

  public func toDict() -> [String : Any] {
    return ["type": "location",
            "title": title,
            "address": address,
            "latitude": location.latitude,
            "longitude": location.longitude]
  }
  
}

