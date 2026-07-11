import XCTest

// UI integration tests for the thread quote block.
// Stubs — promote to full XCUITest when the UITest target is added to the project.

final class ThreadQuoteUITests: XCTestCase {

    // AC-15.1: Given a message is long-pressed When "Quote" is tapped in the context menu
    //          Then QuoteBlockView appears in the composer with the quoted message's first 80 chars
    func testQuoteBlockAppearsOnLongPress() throws {
        // AC-15.1
        throw XCTSkip("UI test stub — requires HelloWorldUITests scheme wired to the app target")
    }
}
