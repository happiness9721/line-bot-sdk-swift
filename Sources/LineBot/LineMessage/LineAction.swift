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

  case postback(label: String?, data: String, displayText: String?)
  case message(label: String?, text: String)
  case uri(label: String?, uri: String)
  case datetimePicker(label: String?, data: String, mode: LineDatetimePickerMode, initial: Date?, max: Date?, min: Date?)

}

internal extension LineAction {

  internal func toDict() -> [String: Any] {
    var dict = [String: Any]()
    switch self {
    case .postback(let label, let data, let displayText):
      dict["type"] = "postback"
      dict["label"] = label
      dict["data"] = data
      dict["displayText"] = displayText
    case .message(let label, let text):
      dict["type"] = "message"
      dict["label"] = label
      dict["text"] = text
    case .uri(let label, let uri):
      dict["type"] = "uri"
      dict["label"] = label
      dict["uri"] = uri
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
      dict["type"] = "datetimepicker"
      dict["label"] = label
      dict["data"] = data
      dict["mode"] = mode.rawValue
      if let initial = initial {
        dict["initial"] = dateFormatter.string(from: initial)
      }
      if let max = max {
        dict["max"] = dateFormatter.string(from: max)
      }
      if let min = min {
        dict["min"] = dateFormatter.string(from: min)
      }
    }
    return dict
  }

}
