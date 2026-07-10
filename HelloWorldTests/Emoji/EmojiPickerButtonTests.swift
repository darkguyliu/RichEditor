import Testing
@testable import HelloWorld

@Suite("EmojiPickerButton")
struct EmojiPickerButtonTests {

    @Test("AC-13.1 (smoke): EmojiPickerButton initializes and notification name is defined")
    func testButtonInitializes() {
        // AC-13.1 — manual check for keyboard presentation; this is a compile/init smoke test
        let button = EmojiPickerButton()
        _ = button
        #expect(NSNotification.Name.emojiPickerRequested.rawValue == "com.helloworld.emojiPickerRequested")
    }
}
