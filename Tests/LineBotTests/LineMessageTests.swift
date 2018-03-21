//
//  LineMessageTests.swift
//  LineBotTests
//
//  Created by happiness9721 on 2018/3/17.
//

import XCTest
@testable import LineBot

class LineMessageTests : XCTestCase {
  func testText() {
    let message = LineMessage.text(text: "Hello, world")
    let messageData = try! JSONSerialization.data(withJSONObject: message.toDict(),
                                                  options: .prettyPrinted)

    let expectedDict = [
      "type": "text",
      "text": "Hello, world"
    ]
    let expectedData = try! JSONSerialization.data(withJSONObject: expectedDict,
                                                   options: .prettyPrinted)
    XCTAssertEqual(String(data: messageData, encoding: .utf8),
                   String(data: expectedData, encoding: .utf8))
  }

  func testImagemap() {
    let message = LineMessage.imagemap(baseUrl: "https://example.com/bot/images/rm001",
                                       altText: "This is an imagemap",
                                       baseSize: CGSize(width: 1040, height: 1040),
                                       actions: [.uri(label: nil,
                                                      linkUri: "https://example.com/",
                                                      area: CGRect(x: 0, y: 0, width: 520, height: 1040)),
                                                 .message(label: nil,
                                                          text: "Hello",
                                                          area: CGRect(x: 520, y: 0, width: 520, height: 1040))])
    let messageData = try! JSONSerialization.data(withJSONObject: message.toDict(),
                                                  options: .prettyPrinted)

    let expectedDict = [
      "type": "imagemap",
      "baseUrl": "https://example.com/bot/images/rm001",
      "altText": "This is an imagemap",
      "baseSize": [
        "height": 1040,
        "width": 1040
      ],
      "actions": [
        [
          "type": "uri",
          "linkUri": "https://example.com/",
          "area": [
            "x": 0,
            "y": 0,
            "width": 520,
            "height": 1040
          ]
        ],
        [
          "type": "message",
          "text": "Hello",
          "area": [
            "x": 520,
            "y": 0,
            "width": 520,
            "height": 1040
          ]
        ]
      ]
    ] as [String : Any]
    let expectedData = try! JSONSerialization.data(withJSONObject: expectedDict,
                                                   options: .prettyPrinted)
    XCTAssertEqual(String(data: messageData, encoding: .utf8),
                   String(data: expectedData, encoding: .utf8))

  }
}
