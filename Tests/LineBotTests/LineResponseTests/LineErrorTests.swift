//
//  LineErrorTests.swift
//  LineBotTests
//
//  Created by happiness9721 on 2018/9/19.
//

import XCTest
@testable import LineBot

class LineErrorTests : XCTestCase {
  func testDecodeErrorResponse() {
    let json =
      """
      {
         "message":"The request body has 2 error(s)",
         "details":[
            {
               "message":"May not be empty",
               "property":"messages[0].text"
            },
            {
               "message":"Must be one of the following values: [text, image, video, audio, location, sticker, template, imagemap]",
               "property":"messages[1].type"
            }
         ]
      }
      """
    let decoder = JSONDecoder()
    let content = try! decoder.decode(LineError.Content.self, from: json.data(using: .utf8)!)
    let error = LineError(statusCode: 400, content: content)
    XCTAssertEqual(error.statusCode, 400)
    XCTAssertEqual(error.content.message, "The request body has 2 error(s)")
    XCTAssertEqual(error.content.details?.count, 2)
    XCTAssertEqual(error.content.details?[0].message, "May not be empty")
    XCTAssertEqual(error.content.details?[0].property, "messages[0].text")
    XCTAssertEqual(error.content.details?[1].message, "Must be one of the following values: [text, image, video, audio, location, sticker, template, imagemap]")
    XCTAssertEqual(error.content.details?[1].property, "messages[1].type")
  }

  func testInvalidReplyTokenErrorResponse() {
    let json =
    """
      {
         "message":"Invalid reply token"
      }
    """
    let decoder = JSONDecoder()
    let content = try! decoder.decode(LineError.Content.self, from: json.data(using: .utf8)!)
    let error = LineError(statusCode: 400, content: content)
    XCTAssertEqual(error.statusCode, 400)
    XCTAssertEqual(error.content.message, "Invalid reply token")
    XCTAssertNil(error.content.details)
  }

  static let allTests = [
    ("testDecodeErrorResponse", testDecodeErrorResponse),
    ("testInvalidReplyTokenErrorResponse", testInvalidReplyTokenErrorResponse)
  ]
}
