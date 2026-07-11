import Testing
import Foundation
import UIKit
@testable import HelloWorld

@Suite("ListManager")
@MainActor
struct ListManagerTests {

    let bulletListKey = NSAttributedString.Key("com.helloworld.bulletList")
    let numberedListKey = NSAttributedString.Key("com.helloworld.numberedList")

    // AC-4.1
    @Test("AC-4.1: Bullet item with content — handleReturn continues the list")
    func testBulletContinuation() {
        // AC-4.1
        var manager = ListManager()

        let textView = UITextView()
        let text = "apple"
        let attrString = NSMutableAttributedString(string: text)
        attrString.addAttribute(bulletListKey, value: true, range: NSRange(location: 0, length: text.count))
        textView.textStorage.setAttributedString(attrString)

        // Place cursor at end of "apple"
        textView.selectedRange = NSRange(location: text.count, length: 0)

        let handled = manager.handleReturn(in: textView)

        #expect(handled == true, "handleReturn should return true for bullet item with content")

        // There should now be a newline inserted, making string "apple\n"
        let resultString = textView.textStorage.string
        #expect(resultString.contains("\n"), "A newline should have been inserted")

        // The new paragraph should have bullet attribute
        let newParaLocation = text.count + 1
        if newParaLocation < textView.textStorage.length {
            let newAttrs = textView.textStorage.attributes(
                at: newParaLocation,
                effectiveRange: nil
            )
            let hasBullet = newAttrs[bulletListKey] as? Bool == true
            #expect(hasBullet, "New paragraph should have bullet list attribute")
        }

        // Cursor should be after the newline
        #expect(textView.selectedRange.location == text.count + 1)
    }

    // AC-4.2
    @Test("AC-4.2: Empty bullet item — handleReturn exits the list")
    func testBulletExitOnEmptyItem() {
        // AC-4.2
        var manager = ListManager()

        let textView = UITextView()
        // Paragraph is empty (just whitespace after stripping "- " prefix)
        let text = " "
        let attrString = NSMutableAttributedString(string: text)
        attrString.addAttribute(bulletListKey, value: true, range: NSRange(location: 0, length: text.count))
        textView.textStorage.setAttributedString(attrString)

        // Cursor at end
        textView.selectedRange = NSRange(location: text.count, length: 0)

        let handled = manager.handleReturn(in: textView)

        #expect(handled == true, "handleReturn should return true when exiting bullet list")

        // Bullet attribute should be removed from the paragraph
        let attrs = textView.textStorage.attributes(at: 0, effectiveRange: nil)
        let hasBullet = attrs[bulletListKey] as? Bool == true
        #expect(!hasBullet, "Bullet attribute should be removed when exiting list")

        // No newline should have been inserted
        #expect(!textView.textStorage.string.contains("\n"), "No newline should be inserted on list exit")
    }

    // AC-4.3
    @Test("AC-4.3: Numbered list item 2 — handleReturn inserts item with index 3")
    func testNumberedListContinuation() {
        // AC-4.3
        var manager = ListManager()

        let textView = UITextView()
        // Two numbered items
        let text = "first\nsecond"
        let attrString = NSMutableAttributedString(string: text)
        attrString.addAttribute(numberedListKey, value: 1, range: NSRange(location: 0, length: 5))
        attrString.addAttribute(numberedListKey, value: 2, range: NSRange(location: 6, length: 6))
        textView.textStorage.setAttributedString(attrString)

        // Cursor at end of "second" (index 12)
        textView.selectedRange = NSRange(location: text.count, length: 0)

        let handled = manager.handleReturn(in: textView)

        #expect(handled == true, "handleReturn should return true for numbered list item with content")

        // There should be a newline inserted
        let resultString = textView.textStorage.string
        #expect(resultString.contains("\n"), "A newline should have been inserted")

        // Cursor should move to position after the inserted newline
        let expectedCursorPos = text.count + 1
        #expect(textView.selectedRange.location == expectedCursorPos)

        // The new paragraph should have numberedList attribute = 3
        let newParaLocation = text.count + 1
        if newParaLocation < textView.textStorage.length {
            let newAttrs = textView.textStorage.attributes(
                at: newParaLocation,
                effectiveRange: nil
            )
            let indexValue = newAttrs[numberedListKey] as? Int
            #expect(indexValue == 3, "New paragraph should have numbered list index 3, got \(String(describing: indexValue))")
        } else {
            // The newline itself (at text.count) carries the attribute
            let newlineAttrs = textView.textStorage.attributes(
                at: text.count,
                effectiveRange: nil
            )
            let indexValue = newlineAttrs[numberedListKey] as? Int
            #expect(indexValue == 3, "Inserted newline should have numbered list index 3, got \(String(describing: indexValue))")
        }
    }
}
