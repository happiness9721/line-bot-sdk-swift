//
//  LineImagemapAction.swift
//  LineBot
//
//  Created by happiness9721 on 2018/3/17.
//

import Foundation

public enum LineImagemapAction {

  case uri(label: String?, linkUri: String, area: CGRect)
  case message(label: String?, text: String, area: CGRect)

}

internal extension LineImagemapAction {

  internal func toDict() -> [String: Any] {
    var action = [String: Any]()
    switch self {
    case .uri(let label, let linkUri, let area):
      action["type"] = "uri"
      action["label"] = label
      action["linkUri"] = linkUri
      action["area"] = ["x": area.origin.x,
                        "y": area.origin.y,
                        "width": area.width,
                        "height": area.height]
    case .message(let label, let text, let area):
      action["type"] = "message"
      action["label"] = label
      action["text"] = text
      action["area"] = ["x": area.origin.x,
                        "y": area.origin.y,
                        "width": area.width,
                        "height": area.height]
    }
    return action
  }
  
}
