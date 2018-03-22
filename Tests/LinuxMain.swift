#if os(Linux)

import XCTest
@testable import LineBotTests

XCTMain([
    testCase(LineBotTests.allTests),
    testCase(LineMessageTests.allTests),
    testCase(LineEventMessageTests.allTests),
    testCase(LineWebhookTests.allTests),
])

#endif
