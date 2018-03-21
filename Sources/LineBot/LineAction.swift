//
//  LineAction.swift
//  LineBot
//
//  Created by happiness9721 on 2018/3/17.
//

import Foundation

public enum LineDatetimePickerMode: String {

  case date = "date"
  case time = "time"
  case datetime = "datetime"

}

public enum LineAction {

  case postback(label: String?, data: String, displayText: String?, text: String?)
  case message(label: String?, text: String)
  case uri(label: String?, uri: String)
  case datetimePicker(label: String?, data: String, mode: LineDatetimePickerMode, initial: Date?, max: Date?, min: Date?)

}

internal extension LineAction {

  internal func toDict() -> [String: Any] {
    var action = [String: Any]()
    switch self {
    case .postback(let label, let data, let displayText, let text):
      action["type"] = "postback"
      action["label"] = label
      action["data"] = data
      action["displayText"] = displayText
      action["text"] = text
    case .message(let label, let text):
      action["type"] = "message"
      action["label"] = label
      action["text"] = text
    case .uri(let label, let uri):
      action["type"] = "uri"
      action["label"] = label
      action["uri"] = uri
    case .datetimePicker(let label, let data, let mode, let initial, let max, let min):
      let dateFormatter = DateFormatter()
      switch mode {
      case .date:
        dateFormatter.dateFormat = "yyyy-MM-dd"
      case .time:
        dateFormatter.dateFormat = "HH:mm"
      case .datetime:
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
      }
      action["type"] = "datetimepicker"
      action["label"] = label
      action["data"] = data
      action["mode"] = mode.rawValue
      if let initial = initial {
        action["initial"] = dateFormatter.string(from: initial)
      }
      if let max = max {
        action["max"] = dateFormatter.string(from: max)
      }
      if let min = min {
        action["min"] = dateFormatter.string(from: min)
      }
    }
    return action
  }

}
