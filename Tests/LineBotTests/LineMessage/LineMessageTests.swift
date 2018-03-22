//
//  LineMessageTests.swift
//  LineBotTests
//
//  Created by happiness9721 on 2018/3/17.
//

import XCTest
@testable import LineBot

class LineMessageTests : XCTestCase {
  func testDecodeText() {
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

  func testDecodeSticker() {
    let message = LineMessage.sticker(packageId: "1", stickerId: "1")
    let messageData = try! JSONSerialization.data(withJSONObject: message.toDict(),
                                                  options: .prettyPrinted)

    let expectedDict = [
      "type": "sticker",
      "packageId": "1",
      "stickerId": "1"
    ]
    let expectedData = try! JSONSerialization.data(withJSONObject: expectedDict,
                                                   options: .prettyPrinted)
    XCTAssertEqual(String(data: messageData, encoding: .utf8),
                   String(data: expectedData, encoding: .utf8))
  }

  func testDecodeImage() {
    let message = LineMessage.image(originalContentUrl: "https://example.com/original.jpg",
                                    previewImageUrl: "https://example.com/preview.jpg")
    let messageData = try! JSONSerialization.data(withJSONObject: message.toDict(),
                                                  options: .prettyPrinted)

    let expectedDict = [
      "type": "image",
      "originalContentUrl": "https://example.com/original.jpg",
      "previewImageUrl": "https://example.com/preview.jpg"
    ]
    let expectedData = try! JSONSerialization.data(withJSONObject: expectedDict,
                                                   options: .prettyPrinted)
    XCTAssertEqual(String(data: messageData, encoding: .utf8),
                   String(data: expectedData, encoding: .utf8))
  }

  func testDecodeVideo() {
    let message = LineMessage.video(originalContentUrl: "https://example.com/original.mp4",
                                    previewImageUrl: "https://example.com/preview.jpg")
    let messageData = try! JSONSerialization.data(withJSONObject: message.toDict(),
                                                  options: .prettyPrinted)

    let expectedDict = [
      "type": "video",
      "originalContentUrl": "https://example.com/original.mp4",
      "previewImageUrl": "https://example.com/preview.jpg"
    ]
    let expectedData = try! JSONSerialization.data(withJSONObject: expectedDict,
                                                   options: .prettyPrinted)
    XCTAssertEqual(String(data: messageData, encoding: .utf8),
                   String(data: expectedData, encoding: .utf8))
  }

  func testDecodeAudio() {
    let message = LineMessage.audio(originalContentUrl: "https://example.com/original.m4a",
                                    duration: 60000)
    let messageData = try! JSONSerialization.data(withJSONObject: message.toDict(),
                                                  options: .prettyPrinted)

    let expectedDict = [
      "type": "audio",
      "originalContentUrl": "https://example.com/original.m4a",
      "duration": 60000
    ] as [String : Any]
    let expectedData = try! JSONSerialization.data(withJSONObject: expectedDict,
                                                   options: .prettyPrinted)
    XCTAssertEqual(String(data: messageData, encoding: .utf8),
                   String(data: expectedData, encoding: .utf8))
  }

  func testDecodeLocation() {
    let message = LineMessage.location(title: "my location",
                                       address: "〒150-0002 東京都渋谷区渋谷２丁目２１−１",
                                       latitude: 35.65910807942215,
                                       longitude: 139.70372892916203)
    let messageData = try! JSONSerialization.data(withJSONObject: message.toDict(),
                                                  options: .prettyPrinted)

    let expectedDict = [
      "type": "location",
      "title": "my location",
      "address": "〒150-0002 東京都渋谷区渋谷２丁目２１−１",
      "latitude": 35.65910807942215,
      "longitude": 139.70372892916203
    ] as [String : Any]
    let expectedData = try! JSONSerialization.data(withJSONObject: expectedDict,
                                                   options: .prettyPrinted)
    XCTAssertEqual(String(data: messageData, encoding: .utf8),
                   String(data: expectedData, encoding: .utf8))
  }

  func testDecodeImagemap() {
    let message = LineMessage.imagemap(baseUrl: "https://example.com/bot/images/rm001",
                                       altText: "This is an imagemap",
                                       width: 1040,
                                       height: 1040,
                                       actions: [.uri(label: nil,
                                                      linkUri: "https://example.com/",
                                                      area: LineArea(x: 0, y: 0, width: 520, height: 1040)),
                                                 .message(label: nil,
                                                          text: "Hello",
                                                          area: LineArea(x: 520, y: 0, width: 520, height: 1040))])
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

  func testDecodeTemplateButtons() {
    var button = LineTemplate.Button(text: "Please select",
                                     actions: [.postback(label: "Buy", data: "action=buy&itemid=123", displayText: nil, text: nil),
                                               .postback(label: "Add to cart", data: "action=add&itemid=123", displayText: nil, text: nil),
                                               .uri(label: "View detail", uri: "http://example.com/page/123")])
    button.thumbnailImageUrl = "https://example.com/bot/images/image.jpg"
    button.imageAspectRatio = .rectangle
    button.imageSize = .cover
    button.imageBackgroundColor = "#FFFFFF"
    button.title = "Menu"
    button.defaultAction = .uri(label: "View detail", uri: "http://example.com/page/123")

    let message = LineMessage.template(altText: "This is a buttons template",
                                       template: .button(button))
    let messageData = try! JSONSerialization.data(withJSONObject: message.toDict(),
                                                  options: .prettyPrinted)

    let expectedDict = [
      "type": "template",
      "altText": "This is a buttons template",
      "template": [
        "type": "buttons",
        "thumbnailImageUrl": "https://example.com/bot/images/image.jpg",
        "imageAspectRatio": "rectangle",
        "imageSize": "cover",
        "imageBackgroundColor": "#FFFFFF",
        "title": "Menu",
        "text": "Please select",
        "defaultAction": [
          "type": "uri",
          "label": "View detail",
          "uri": "http://example.com/page/123"
        ],
        "actions": [
          [
            "type": "postback",
            "label": "Buy",
            "data": "action=buy&itemid=123"
          ],
          [
            "type": "postback",
            "label": "Add to cart",
            "data": "action=add&itemid=123"
          ],
          [
            "type": "uri",
            "label": "View detail",
            "uri": "http://example.com/page/123"
          ]
        ]
      ]
    ] as [String : Any]
    let expectedData = try! JSONSerialization.data(withJSONObject: expectedDict,
                                                   options: .prettyPrinted)
    XCTAssertEqual(String(data: messageData, encoding: .utf8),
                   String(data: expectedData, encoding: .utf8))
  }

  func testDecodeTemplateConfirm() {
    let message = LineMessage.template(altText: "this is a confirm template",
                                       template: .confirm(.init(text: "Are you sure?",
                                                                actions: [.message(label: "Yes", text: "yes"),
                                                                          .message(label: "No", text: "no")])))
    let messageData = try! JSONSerialization.data(withJSONObject: message.toDict(),
                                                  options: .prettyPrinted)

    let expectedDict = [
      "type": "template",
      "altText": "this is a confirm template",
      "template": [
        "type": "confirm",
        "text": "Are you sure?",
        "actions": [
          [
            "type": "message",
            "label": "Yes",
            "text": "yes"
          ],
          [
            "type": "message",
            "label": "No",
            "text": "no"
          ]
        ]
      ]
    ] as [String : Any]
    let expectedData = try! JSONSerialization.data(withJSONObject: expectedDict,
                                                   options: .prettyPrinted)
    XCTAssertEqual(String(data: messageData, encoding: .utf8),
                   String(data: expectedData, encoding: .utf8))
  }

  func testDecodeTemplateCarousel() {
    var columns = [LineTemplate.Carousel.Column]()
    columns.append(LineTemplate.Carousel.Column.init(thumbnailImageUrl: "https://example.com/bot/images/item1.jpg",
                                                     imageBackgroundColor: "#FFFFFF",
                                                     title: "this is menu",
                                                     text: "description",
                                                     defaultAction: .uri(label: "View detail", uri: "http://example.com/page/123"),
                                                     actions: [.postback(label: "Buy", data: "action=buy&itemid=111", displayText: nil, text: nil),
                                                               .postback(label: "Add to cart", data: "action=add&itemid=111", displayText: nil, text: nil),
                                                               .uri(label: "View detail", uri: "http://example.com/page/111")]))
    columns.append(LineTemplate.Carousel.Column.init(thumbnailImageUrl: "https://example.com/bot/images/item2.jpg",
                                                     imageBackgroundColor: "#000000",
                                                     title: "this is menu",
                                                     text: "description",
                                                     defaultAction: .uri(label: "View detail", uri: "http://example.com/page/222"),
                                                     actions: [.postback(label: "Buy", data: "action=buy&itemid=222", displayText: nil, text: nil),
                                                               .postback(label: "Add to cart", data: "action=add&itemid=222", displayText: nil, text: nil),
                                                               .uri(label: "View detail", uri: "http://example.com/page/222")]))
    let message = LineMessage.template(altText: "this is a carousel template",
                                       template: .carousel(.init(columns: columns,
                                                                 imageAspectRatio: .rectangle,
                                                                 imageSize: .cover)))
    let messageData = try! JSONSerialization.data(withJSONObject: message.toDict(),
                                                  options: .prettyPrinted)

    let expectedDict = [
      "type": "template",
      "altText": "this is a carousel template",
      "template": [
        "type": "carousel",
        "columns": [
          [
            "thumbnailImageUrl": "https://example.com/bot/images/item1.jpg",
            "imageBackgroundColor": "#FFFFFF",
            "title": "this is menu",
            "text": "description",
            "defaultAction": [
              "type": "uri",
              "label": "View detail",
              "uri": "http://example.com/page/123"
            ],
            "actions": [
              [
                "type": "postback",
                "label": "Buy",
                "data": "action=buy&itemid=111"
              ],
              [
                "type": "postback",
                "label": "Add to cart",
                "data": "action=add&itemid=111"
              ],
              [
                "type": "uri",
                "label": "View detail",
                "uri": "http://example.com/page/111"
              ]
            ]
          ],
          [
            "thumbnailImageUrl": "https://example.com/bot/images/item2.jpg",
            "imageBackgroundColor": "#000000",
            "title": "this is menu",
            "text": "description",
            "defaultAction": [
              "type": "uri",
              "label": "View detail",
              "uri": "http://example.com/page/222"
            ],
            "actions": [
              [
                "type": "postback",
                "label": "Buy",
                "data": "action=buy&itemid=222"
              ],
              [
                "type": "postback",
                "label": "Add to cart",
                "data": "action=add&itemid=222"
              ],
              [
                "type": "uri",
                "label": "View detail",
                "uri": "http://example.com/page/222"
              ]
            ]
          ]
        ],
        "imageAspectRatio": "rectangle",
        "imageSize": "cover"
      ]
    ] as [String : Any]
    let expectedData = try! JSONSerialization.data(withJSONObject: expectedDict,
                                                   options: .prettyPrinted)
    XCTAssertEqual(String(data: messageData, encoding: .utf8),
                   String(data: expectedData, encoding: .utf8))
  }

  func testDecodeTemplateImageCarousel() {
    let message = LineMessage.template(altText: "this is a image carousel template",
                                       template: .imageCarousel(.init(columns: [.init(imageUrl: "https://example.com/bot/images/item1.jpg",
                                                                                      action: .postback(label: "Buy",
                                                                                                        data: "action=buy&itemid=111",
                                                                                                        displayText: nil,
                                                                                                        text: nil)),
                                                                                .init(imageUrl: "https://example.com/bot/images/item2.jpg",
                                                                                      action: .message(label: "Yes", text: "yes")),
                                                                                .init(imageUrl: "https://example.com/bot/images/item3.jpg",
                                                                                      action: .uri(label: "View detail", uri: "http://example.com/page/222"))
                                                                                ])))
    let messageData = try! JSONSerialization.data(withJSONObject: message.toDict(),
                                                  options: .prettyPrinted)

    let expectedDict = [
      "type": "template",
      "altText": "this is a image carousel template",
      "template": [
        "type": "image_carousel",
        "columns": [
          [
            "imageUrl": "https://example.com/bot/images/item1.jpg",
            "action": [
              "type": "postback",
              "label": "Buy",
              "data": "action=buy&itemid=111"
            ]
          ],
          [
            "imageUrl": "https://example.com/bot/images/item2.jpg",
            "action": [
              "type": "message",
              "label": "Yes",
              "text": "yes"
            ]
          ],
          [
            "imageUrl": "https://example.com/bot/images/item3.jpg",
            "action": [
              "type": "uri",
              "label": "View detail",
              "uri": "http://example.com/page/222"
            ]
          ]
        ]
      ]
    ] as [String : Any]
    let expectedData = try! JSONSerialization.data(withJSONObject: expectedDict,
                                                   options: .prettyPrinted)
    XCTAssertEqual(String(data: messageData, encoding: .utf8),
                   String(data: expectedData, encoding: .utf8))
  }

  static let allTests = [
    ("testDecodeText", testDecodeText),
    ("testDecodeSticker", testDecodeSticker),
    ("testDecodeImage", testDecodeImage),
    ("testDecodeVideo", testDecodeVideo),
    ("testDecodeAudio", testDecodeAudio),
    ("testDecodeLocation", testDecodeLocation),
    ("testDecodeImagemap", testDecodeImagemap),
    ("testDecodeTemplateButtons", testDecodeTemplateButtons),
    ("testDecodeTemplateConfirm", testDecodeTemplateConfirm),
    ("testDecodeTemplateCarousel", testDecodeTemplateCarousel),
    ("testDecodeTemplateImageCarousel", testDecodeTemplateImageCarousel)
  ]
}
