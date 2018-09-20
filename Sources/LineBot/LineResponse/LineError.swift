//
//  LineError.swift
//  LineBot
//
//  Created by happiness9721 on 2018/9/19.
//

import Foundation

public struct LineError: Error {

  public let statusCode: Int
  public let content: Content

  public struct Content: Codable {

    public let message: String
    public let details: [Detail]?

    public struct Detail: Codable {

      public let message: String
      public let property: String

    }

  }

}

extension LineError: LocalizedError {
  public var errorDescription: String? {
    var description =
      """
      ⚠️ Line Error Code \(statusCode): \(content.message)
      """
    if let details = content.details {
      let detailMessage = details
        .map {
          "\n  {\n    message: \"\($0.message)\",\n    property: \"\($0.property)\"\n  }"
        }
        .joined(separator: ",")
      description = "\(description)\n[\(detailMessage)\n]"
    }
    return description
  }
}
