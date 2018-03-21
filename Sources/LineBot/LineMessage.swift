//
//  LineMessage.swift
//  LineBot
//
//  Created by happiness9721 on 2017/12/1.
//

import Foundation

public enum LineMessage {

  case text(text: String)
  case sticker(packageId: String, stickerId: String)
  case image(originalContentUrl: String, previewImageUrl: String)
  case video(originalContentUrl: String, previewImageUrl: String)
  case audio(originalContentUrl: String, duration: Int)
  case location(title: String, address: String, latitude: Double, longitude: Double)
  case imagemap(baseUrl: String, altText: String, baseSize: CGSize, actions: [LineImagemapAction])

}

internal extension LineMessage {

  internal func toDict() -> [String: Any] {
    switch self {
    case .text(let text):
      return ["type": "text",
              "text": text]
    case .sticker(let packageId, let stickerId):
      return ["type": "sticker",
              "packageId": packageId,
              "stickerId": stickerId]
    case .image(let originalContentUrl, let previewImageUrl):
      return ["type": "image",
              "originalContentUrl": originalContentUrl,
              "previewImageUrl": previewImageUrl]
    case .video(let originalContentUrl, let previewImageUrl):
      return ["type": "video",
              "originalContentUrl": originalContentUrl,
              "previewImageUrl": previewImageUrl]
    case .audio(let originalContentUrl, let duration):
      return ["type": "video",
              "originalContentUrl": originalContentUrl,
              "duration": duration]
    case .location(let title, let address, let latitude, let longitude):
      return ["type": "location",
              "title": title,
              "address": address,
              "latitude": latitude,
              "longitude": longitude]
    case .imagemap(let baseUrl, let altText, let baseSize, let actions):
      var mapActions = [[String: Any]]()
      for action in actions {
        mapActions.append(action.toDict())
      }
      return ["type": "imagemap",
              "baseUrl": baseUrl,
              "altText": altText,
              "baseSize": ["height": baseSize.height,
                           "width": baseSize.width],
              "actions": mapActions]
    }
  }

}

