import XCTest

// UI integration tests for the @-mention typeahead overlay.
// Stubs — promote to full XCUITest when the UITest target is added to the project.

final class MentionUITests: XCTestCase {

    // AC-12.3: Given the user types @al in the editor When MentionTypeaheadOverlay renders
    //          Then "Alice Chen" is visible in the suggestions list
    func testTypeaheadFiltersOnQuery() throws {
        // AC-12.3
        throw XCTSkip("UI test stub — requires HelloWorldUITests scheme wired to the app target")
    }

    // AC-12.4: Given "Alice Chen" is visible in the typeahead When the user taps it
    //          Then @alice is inserted at the cursor and the overlay dismisses
    func testSelectingMentionInsertsUsername() throws {
        // AC-12.4
        throw XCTSkip("UI test stub — requires HelloWorldUITests scheme wired to the app target")
    }
}
