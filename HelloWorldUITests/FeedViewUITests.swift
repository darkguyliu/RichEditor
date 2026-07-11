import XCTest

// UI integration tests for FeedView.
// Stubs — promote to full XCUITest when the UITest target is added to the project.

final class FeedViewUITests: XCTestCase {

    // AC-9.3: Given a new message is submitted via viewModel.submit()
    //         When FeedView updates Then it auto-scrolls to the new message (bottom of scroll)
    func testAutoScrollOnNewMessage() throws {
        // AC-9.3
        throw XCTSkip("UI test stub — requires HelloWorldUITests scheme wired to the app target")
    }
}
