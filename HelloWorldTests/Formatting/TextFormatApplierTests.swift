import Testing
import UIKit
@testable import HelloWorld

@Suite("TextFormatApplier")
struct TextFormatApplierTests {

    let applier = TextFormatApplier()

    // AC-3.1: Plain text → toggle bold → range has .traitBold
    @Test("AC-3.1: Apply bold to plain-text range")
    func testApplyBold() {
        // AC-3.1
        let storage = NSTextStorage(string: "hello")
        let range = NSRange(location: 0, length: 5)

        applier.toggle(.bold, in: storage, range: range)

        // Font descriptor should have .traitBold
        var hasBoldTrait = false
        storage.enumerateAttribute(.font, in: range, options: []) { value, _, _ in
            if let font = value as? UIFont {
                hasBoldTrait = font.fontDescriptor.symbolicTraits.contains(.traitBold)
            }
        }
        #expect(hasBoldTrait, "Expected .traitBold after toggling bold on a plain range")

        // Custom key must also be set (required by MarkdownAttributedStringConverter)
        let boldKeyValue = storage.attribute(
            NSAttributedString.Key("com.helloworld.bold"),
            at: 0,
            effectiveRange: nil
        ) as? Bool
        #expect(boldKeyValue == true, "Expected com.helloworld.bold key to be true")
    }

    // AC-3.2: Fully-bold range → toggle bold again → bold trait removed
    @Test("AC-3.2: Toggle bold off when entire range is bold")
    func testToggleBoldOff() {
        // AC-3.2
        let storage = NSTextStorage(string: "hello")
        let range = NSRange(location: 0, length: 5)

        // Apply bold first
        applier.toggle(.bold, in: storage, range: range)
        // Toggle off
        applier.toggle(.bold, in: storage, range: range)

        var hasBoldTrait = false
        storage.enumerateAttribute(.font, in: range, options: []) { value, _, _ in
            if let font = value as? UIFont {
                hasBoldTrait = font.fontDescriptor.symbolicTraits.contains(.traitBold)
            }
        }
        #expect(!hasBoldTrait, "Expected .traitBold to be removed after second toggle")

        let boldKeyValue = storage.attribute(
            NSAttributedString.Key("com.helloworld.bold"),
            at: 0,
            effectiveRange: nil
        ) as? Bool
        #expect(boldKeyValue != true, "Expected com.helloworld.bold key to be absent/false after toggle off")
    }

    // AC-3.3: Mixed bold/plain range → toggle bold → entire range becomes bold
    @Test("AC-3.3: Apply bold to partially bold range makes entire range bold")
    func testApplyBoldToPartialRange() {
        // AC-3.3
        let storage = NSTextStorage(string: "hello")
        let fullRange = NSRange(location: 0, length: 5)

        // Make only "hel" bold (first 3 chars)
        let partialRange = NSRange(location: 0, length: 3)
        applier.toggle(.bold, in: storage, range: partialRange)

        // Now toggle bold on the full range (partial coverage → apply to all)
        applier.toggle(.bold, in: storage, range: fullRange)

        // All 5 characters should be bold
        var allBold = true
        storage.enumerateAttribute(.font, in: fullRange, options: []) { value, _, _ in
            if let font = value as? UIFont {
                if !font.fontDescriptor.symbolicTraits.contains(.traitBold) {
                    allBold = false
                }
            }
        }
        #expect(allBold, "Expected entire range to be bold after toggling with partial coverage")
    }

    // AC-3.4: Bold range → toggle italic on same range → both bold and italic traits present
    @Test("AC-3.4: Bold and italic traits coexist on the same range")
    func testBoldAndItalicCoexist() {
        // AC-3.4
        let storage = NSTextStorage(string: "hello")
        let range = NSRange(location: 0, length: 5)

        applier.toggle(.bold, in: storage, range: range)
        applier.toggle(.italic, in: storage, range: range)

        var hasBold = false
        var hasItalic = false
        storage.enumerateAttribute(.font, in: range, options: []) { value, _, _ in
            if let font = value as? UIFont {
                let traits = font.fontDescriptor.symbolicTraits
                if traits.contains(.traitBold) { hasBold = true }
                if traits.contains(.traitItalic) { hasItalic = true }
            }
        }
        #expect(hasBold, "Expected .traitBold to be present")
        #expect(hasItalic, "Expected .traitItalic to be present")

        let boldKey = storage.attribute(
            NSAttributedString.Key("com.helloworld.bold"),
            at: 0,
            effectiveRange: nil
        ) as? Bool
        let italicKey = storage.attribute(
            NSAttributedString.Key("com.helloworld.italic"),
            at: 0,
            effectiveRange: nil
        ) as? Bool
        #expect(boldKey == true, "Expected com.helloworld.bold key to be true")
        #expect(italicKey == true, "Expected com.helloworld.italic key to be true")
    }
}
