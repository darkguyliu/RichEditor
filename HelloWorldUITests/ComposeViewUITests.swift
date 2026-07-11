import XCTest

// UI integration tests for ComposeView.
// These tests require a running app target (HelloWorldUITests scheme).
// Currently stubs — promote to full XCUITest when the UITest target is added to the project.

final class ComposeViewUITests: XCTestCase {

    // AC-5.2: Given the editor is active When the Bold button is tapped and text is selected
    //         Then TextFormatApplier.toggle(.bold, ...) is applied and UITextView reflects the change
    func testBoldAppliedToSelection() throws {
        // AC-5.2
        throw XCTSkip("UI test stub — requires HelloWorldUITests scheme wired to the app target")
    }

    // AC-8.1: Given ComposeView is presented When the text field is empty
    //         Then the Send button is disabled (opacity 0.4, not tappable)
    func testSendButtonDisabledWhenEmpty() throws {
        // AC-8.1
        throw XCTSkip("UI test stub — requires HelloWorldUITests scheme wired to the app target")
    }

    // AC-8.2: Given text is typed in the input When the Send button is tapped
    //         Then the sheet dismisses and viewModel.messages.count increments by 1
    func testSendDismissesSheet() throws {
        // AC-8.2
        throw XCTSkip("UI test stub — requires HelloWorldUITests scheme wired to the app target")
    }
}
