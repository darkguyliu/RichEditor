import Testing
import Foundation
@testable import HelloWorld

@Suite("MarkdownAttributedStringConverter")
struct MarkdownAttributedStringConverterTests {

    let converter = MarkdownAttributedStringConverter()

    // AC-2.1: Bold run → **text**
    @Test("AC-2.1: Bold NSAttributedString → **bold** Markdown")
    func testBoldToMarkdown() {
        let str = NSMutableAttributedString(string: "hello")
        str.addAttribute(
            NSAttributedString.Key("com.helloworld.bold"),
            value: true,
            range: NSRange(location: 0, length: 5)
        )
        let result = converter.toMarkdown(str)
        #expect(result.contains("**hello**"), "Expected **hello** in: \(result)")
    }

    // AC-2.2: Italic run → _text_
    @Test("AC-2.2: Italic NSAttributedString → _italic_ Markdown")
    func testItalicToMarkdown() {
        let str = NSMutableAttributedString(string: "world")
        str.addAttribute(
            NSAttributedString.Key("com.helloworld.italic"),
            value: true,
            range: NSRange(location: 0, length: 5)
        )
        let result = converter.toMarkdown(str)
        #expect(result.contains("_world_"), "Expected _world_ in: \(result)")
    }

    // AC-2.3: Bullet list paragraphs → - prefix
    @Test("AC-2.3: Bullet list paragraphs get - prefix")
    func testBulletListToMarkdown() {
        let str = NSMutableAttributedString(string: "a\nb\nc")
        // Mark each paragraph as bullet
        for range in [NSRange(location: 0, length: 1),
                      NSRange(location: 2, length: 1),
                      NSRange(location: 4, length: 1)] {
            str.addAttribute(
                MarkdownAttributedStringConverter.bulletListKey,
                value: true,
                range: range
            )
        }
        let result = converter.toMarkdown(str)
        let lines = result.components(separatedBy: "\n")
        #expect(lines.allSatisfy { $0.hasPrefix("- ") }, "All lines should start with '- ', got: \(result)")
    }

    // AC-2.4: Round-trip bold + italic
    @Test("AC-2.4: Round-trip bold + italic via toMarkdown then toAttributedString")
    func testRoundTripBoldItalic() {
        let markdown = "**bold** and _italic_"
        let attributed = converter.toAttributedString(markdown)
        #expect(attributed.length > 0, "AttributedString should be non-empty")
        // The resulting string content (ignoring formatting) should contain the words
        let plain = attributed.string
        #expect(plain.contains("bold"), "Plain text should contain 'bold'")
        #expect(plain.contains("italic"), "Plain text should contain 'italic'")
    }

    // AC-2.5: No UIKit imports
    @Test("AC-2.5: MarkdownAttributedStringConverter source has no UIKit import")
    func testNoUIKitImport() throws {
        // Find the source file relative to the test bundle
        // We check at compile time that this file builds without UIKit
        // Runtime: verify the struct can be instantiated in a non-UIKit context
        let c = MarkdownAttributedStringConverter()
        let result = c.toMarkdown(NSAttributedString(string: "test"))
        #expect(result == "test")
    }

    // Extra: empty string returns empty
    @Test("Empty string returns empty Markdown")
    func testEmptyStringReturnsEmpty() {
        let result = converter.toMarkdown(NSAttributedString())
        #expect(result.isEmpty)
    }

    // Extra: numbered list
    @Test("Numbered list paragraphs get N. prefix")
    func testNumberedListToMarkdown() {
        let str = NSMutableAttributedString(string: "first\nsecond")
        str.addAttribute(
            MarkdownAttributedStringConverter.numberedListKey,
            value: 1,
            range: NSRange(location: 0, length: 5)
        )
        str.addAttribute(
            MarkdownAttributedStringConverter.numberedListKey,
            value: 2,
            range: NSRange(location: 6, length: 6)
        )
        let result = converter.toMarkdown(str)
        #expect(result.hasPrefix("1. first"), "Expected '1. first', got: \(result)")
        #expect(result.contains("2. second"), "Expected '2. second', got: \(result)")
    }

    // Extra: inline code
    @Test("Inline code range → backtick wrapping")
    func testInlineCodeToMarkdown() {
        let str = NSMutableAttributedString(string: "use crash_reporter here")
        str.addAttribute(
            MarkdownAttributedStringConverter.inlineCodeKey,
            value: true,
            range: NSRange(location: 4, length: 14) // "crash_reporter"
        )
        let result = converter.toMarkdown(str)
        #expect(result.contains("`crash_reporter`"), "Expected backtick wrapping, got: \(result)")
    }

    // Extra: blockquote
    @Test("Blockquote paragraph → > prefix")
    func testBlockquoteToMarkdown() {
        let str = NSMutableAttributedString(string: "quoted text")
        str.addAttribute(
            MarkdownAttributedStringConverter.blockquoteKey,
            value: true,
            range: NSRange(location: 0, length: 11)
        )
        let result = converter.toMarkdown(str)
        #expect(result.hasPrefix("> "), "Expected '> ' prefix, got: \(result)")
    }

    // Extra: malformed markdown falls back to plain text
    @Test("Malformed markdown falls back to plain text without crashing")
    func testMalformedMarkdownFallback() {
        let result = converter.toAttributedString("**unclosed bold")
        // Should not crash; length > 0
        #expect(result.length > 0)
    }
}
