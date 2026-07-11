import XCTest

// UI integration tests for the app root (ContentView shell).
// Stubs — promote to full XCUITest when the UITest target is added to the project.

final class AppRootUITests: XCTestCase {

    // AC-10.1: Given the app is launched When the root view appears
    //          Then FeedView is visible (no Text("Hello, World!"))
    func testFeedViewIsRootView() throws {
        // AC-10.1
        throw XCTSkip("UI test stub — requires HelloWorldUITests scheme wired to the app target")
    }

    // AC-10.2: Given the feed is visible When the compose button (pencil icon) is tapped
    //          Then ComposeView sheet appears
    func testComposeSheetPresented() throws {
        // AC-10.2
        throw XCTSkip("UI test stub — requires HelloWorldUITests scheme wired to the app target")
    }

    // AC-10.3: Given a message is submitted in ComposeView When the sheet dismisses
    //          Then the new message appears in FeedView
    func testSubmittedMessageAppearsInFeed() throws {
        // AC-10.3
        throw XCTSkip("UI test stub — requires HelloWorldUITests scheme wired to the app target")
    }
}
