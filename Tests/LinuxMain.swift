#if os(Linux)

import XCTest
@testable import LineBotTests

XCTMain([
    testCase(LineBotTests.allTests),
    testCase(LineErrorTests.allTests),
    testCase(LineMessageTests.allTests),
    testCase(LineEventMessageTests.allTests),
    testCase(LineWebhookTests.allTests),
])

#endif
