//
//  LineWebhookMessageTests.swift
//  LineBotTests
//
//  Created by happiness9721 on 2018/3/20.
//

import XCTest
@testable import LineBot

class LineWebhookMessageTests: XCTestCase {

  func testDecodeText() {
    let json =
    """
    {
      "id": "325708",
      "type": "text",
      "text": "Hello, world"
    }
    """
    do {
      let message = try JSONDecoder().decode(LineWebhookMessage.self, from: json.data(using: .utf8)!)
      switch message {
      case .text(let text):
        XCTAssertEqual(text.id, "325708")
        XCTAssertEqual(text.text, "Hello, world")
      case _:
        XCTFail("type error, expected is text")
      }

    } catch {
      XCTFail(error.localizedDescription)
    }
  }

  func testDecodeImage() {
    let json =
    """
    {
      "id": "325708",
      "type": "image"
    }
    """
    do {
      let message = try JSONDecoder().decode(LineWebhookMessage.self, from: json.data(using: .utf8)!)
      switch message {
      case .image(let content):
        XCTAssertEqual(content.id, "325708")
      case _:
        XCTFail("type error, expected is image")
      }

    } catch {
      XCTFail(error.localizedDescription)
    }
  }

}
