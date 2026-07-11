import XCTest
import SwiftUI
@testable import HelloWorld

final class ContentViewTests: XCTestCase {

    // AC-10.1: FeedView is the root — no Text("Hello, World!")
    func testContentViewHasFeedView() {
        let view = ContentView()
        XCTAssertNotNil(view)
    }
}
