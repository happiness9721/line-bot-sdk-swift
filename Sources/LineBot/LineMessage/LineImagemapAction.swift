//
//  LineImagemapAction.swift
//  LineBot
//
//  Created by happiness9721 on 2018/3/17.
//

import Foundation

public enum LineImagemapAction {

  case uri(label: String?, linkUri: String, area: LineArea)
  case message(label: String?, text: String, area: LineArea)

}

internal extension LineImagemapAction {

  internal func toDict() -> [String: Any] {
    var dict = [String: Any]()
    switch self {
    case .uri(let label, let linkUri, let area):
      dict["type"] = "uri"
      dict["label"] = label
      dict["linkUri"] = linkUri
      dict["area"] = ["x": area.x,
                      "y": area.y,
                      "width": area.width,
                      "height": area.height]
    case .message(let label, let text, let area):
      dict["type"] = "message"
      dict["label"] = label
      dict["text"] = text
      dict["area"] = ["x": area.x,
                      "y": area.y,
                      "width": area.width,
                      "height": area.height]
    }
    return dict
  }
  
}
