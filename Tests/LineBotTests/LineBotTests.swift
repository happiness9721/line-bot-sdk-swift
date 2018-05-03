//
//  LineBotTests.swift
//  LineBotTests
//
//  Created by happiness9721 on 2018/3/22.
//

import XCTest
@testable import LineBot

class LineBotTests: XCTestCase {

  let content =
  """
  {
   "events":[
    {
     "type":"message",
     "timestamp":12345678901234,
     "source":{
      "type":"user",
      "userId":"userid"
     },
     "replyToken":"replytoken",
     "message":{
      "id":"contentid",
      "type":"text",
      "text":"message"
     }
    },
    {
     "type":"message",
     "timestamp":12345678901234,
     "source":{
      "type":"group",
      "groupId":"groupid"
     },
     "replyToken":"replytoken",
     "message":{
      "id":"contentid",
      "type":"image"
     }
    },
    {
     "type":"message",
     "timestamp":12345678901234,
     "source":{
      "type":"room",
      "roomId":"roomid"
     },
     "replyToken":"replytoken",
     "message":{
      "id":"contentid",
      "type":"video"
     }
    },
    {
     "type":"message",
     "timestamp":12345678901234,
     "source":{
      "type":"room",
      "roomId":"roomid"
     },
     "replyToken":"replytoken",
     "message":{
      "id":"contentid",
      "type":"audio"
     }
    },
    {
     "type":"message",
     "timestamp":12345678901234,
     "source":{
      "type":"user",
      "userId":"userid"
     },
     "replyToken":"replytoken",
     "message":{
      "id":"contentid",
      "type":"location",
      "title":"label",
      "address":"tokyo",
      "latitude":-34.12,
      "longitude":134.23
     }
    },
    {
     "type":"message",
     "timestamp":12345678901234,
     "source":{
      "type":"user",
      "userId":"userid"
     },
     "replyToken":"replytoken",
     "message":{
      "id":"contentid",
      "type":"sticker",
      "packageId":"1",
      "stickerId":"2"
     }
    },
    {
     "type":"follow",
     "timestamp":12345678901234,
     "source":{
      "type":"user",
      "userId":"userid"
     },
     "replyToken":"replytoken"
    },
    {
     "type":"unfollow",
     "timestamp":12345678901234,
     "source":{
      "type":"user",
      "userId":"userid"
     }
    },
    {
     "type":"join",
     "timestamp":12345678901234,
     "source":{
      "type":"user",
      "userId":"userid"
     },
     "replyToken":"replytoken"
    },
    {
     "type":"leave",
     "timestamp":12345678901234,
     "source":{
      "type":"user",
      "userId":"userid"
     }
    },
    {
     "type":"postback",
     "timestamp":12345678901234,
     "source":{
      "type":"user",
      "userId":"userid"
     },
     "replyToken":"replytoken",
     "postback.data":"postback"
    },
    {
     "type":"beacon",
     "timestamp":12345678901234,
     "source":{
      "type":"user",
      "userId":"userid"
     },
     "replyToken":"replytoken",
     "beacon.hwid":"bid",
     "beacon.type":"enter"
    }
   ]
  }

  """

  func testValidateSuccess() {
    let bot = LineBot(accessToken: "ACCESS_TOKEN", channelSecret: "testsecret")
    XCTAssertTrue(bot.validateSignature(content: content,
                                        signature: "QHWgy4GThTN7vK1Nh7fRzNVCAIptZuEFm4V1x6mQFp4="))
  }

  func testValidateFailed() {
    let bot = LineBot(accessToken: "ACCESS_TOKEN", channelSecret: "testsecret")
    XCTAssertFalse(bot.validateSignature(content: content,
                                         signature: ""))
  }

  static let allTests = [
    ("testValidateSuccess", testValidateSuccess),
    ("testValidateFailed", testValidateFailed)
  ]

}
