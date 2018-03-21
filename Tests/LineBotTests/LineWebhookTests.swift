//
//  LineWebhookTests.swift
//  LineBotTests
//
//  Created by happiness9721 on 2018/3/17.
//

import XCTest
@testable import LineBot

class LineWebhookTests: XCTestCase {

  func testDecode() {
    let json =
    """
    {
      "events": [
        {
          "replyToken": "nHuyWiB7yP5Zw52FIkcQobQuGDXCTA",
          "type": "message",
          "timestamp": 1462629479859,
          "source": {
            "type": "user",
            "userId": "U4af4980629..."
          },
          "message": {
            "id": "325708",
            "type": "text",
            "text": "Hello, world"
          }
        },
        {
          "replyToken": "nHuyWiB7yP5Zw52FIkcQobQuGDXCTA",
          "type": "follow",
          "timestamp": 1462629479859,
          "source": {
            "type": "user",
            "userId": "U4af4980629..."
          }
        }
      ]
    }
    """
    do {
      let webhook = try JSONDecoder().decode(LineWebhook.self, from: json.data(using: .utf8)!)
      XCTAssertEqual(webhook.events.count, 2)
      switch webhook.events[0] {
      case .message(let event):
        XCTAssertEqual(event.replyToken, "nHuyWiB7yP5Zw52FIkcQobQuGDXCTA")
        XCTAssertEqual(event.timestamp, 1462629479859)
        XCTAssertEqual(event.source.type, .user)
        XCTAssertEqual(event.source.userId, "U4af4980629...")
        switch event.message {
        case .text(let text):
          XCTAssertEqual(text.id, "325708")
          XCTAssertEqual(text.text, "Hello, world")
        case _:
          XCTFail("type error, expected is text")
        }
      case _:
        XCTFail("event type error")
      }
      switch webhook.events[1] {
      case .follow(let event):
        XCTAssertEqual(event.replyToken, "nHuyWiB7yP5Zw52FIkcQobQuGDXCTA")
        XCTAssertEqual(event.timestamp, 1462629479859)
        XCTAssertEqual(event.source.type, .user)
        XCTAssertEqual(event.source.userId, "U4af4980629...")
      case _:
        XCTFail("event type error")
      }
    } catch {
      XCTFail(error.localizedDescription)
    }
  }

}
