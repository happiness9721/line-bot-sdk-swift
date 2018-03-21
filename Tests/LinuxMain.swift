#if os(Linux)

import XCTest
@testable import LineBotTests

XCTMain([
    testCase(LineMessageTests.allTests),
    testCase(LineWebhookMessageTests.allTests),
    testCase(LineWebhookTests.allTests),
])

#endif
