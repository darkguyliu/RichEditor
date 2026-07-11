import XCTest

// UI integration tests for the emoji picker.
// Stubs — promote to full XCUITest when the UITest target is added to the project.
// Note: keyboard-interception tests are unreliable in CI; see AC-13.2.

final class EmojiPickerUITests: XCTestCase {

    // AC-13.2: Given an emoji is selected from the picker When the editor regains focus
    //          Then the emoji character is inserted at the cursor position in UITextView
    func testEmojiInsertedAtCursor() throws {
        // AC-13.2
        throw XCTSkip("UI test stub — emoji keyboard interception may be unreliable in CI")
    }
}
