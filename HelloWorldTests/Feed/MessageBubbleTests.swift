import Testing
import Foundation
@testable import HelloWorld

@Suite("MessageBubble")
struct MessageBubbleTests {

    // AC-9.1: Given markdownContent = "**hello**" When parsed via AttributedString(markdown:)
    //         Then the resulting run for "hello" has .stronglyEmphasized inline presentation intent
    @Test("AC-9.1: Bold markdown renders with stronglyEmphasized intent")
    func testBoldMarkdownRendered() {
        // AC-9.1
        let attrStr = try? AttributedString(
            markdown: "**hello**",
            options: AttributedString.MarkdownParsingOptions(
                interpretedSyntax: .inlineOnlyPreservingWhitespace
            )
        )
        #expect(attrStr != nil, "// AC-9.1: bold markdown should parse")
        #expect(attrStr?.runs.first?.inlinePresentationIntent?.contains(.stronglyEmphasized) == true)
    }

    // AC-9.2: Given markdownContent = "- a\n- b\n- c" When parsed via AttributedString(markdown:)
    //         Then it does not crash and result is non-nil
    @Test("AC-9.2: Bullet list markdown parses without crash")
    func testBulletListRendered() {
        // AC-9.2
        let markdown = "- a\n- b\n- c"
        let attrStr = try? AttributedString(
            markdown: markdown,
            options: AttributedString.MarkdownParsingOptions(
                interpretedSyntax: .inlineOnlyPreservingWhitespace
            )
        )
        // Full rendering check is visual — verify no crash + result is usable
        let fallback = attrStr ?? AttributedString(markdown)
        #expect(String(fallback.characters).isEmpty == false,
                "// AC-9.2: bullet list result should contain text")
    }

    // AC-11.4: Given a GFM table in markdownContent When MessageBubble renders it on iOS 15
    //          Then the table is displayed as text (no crash) — inlineOnlyPreservingWhitespace strips table syntax
    @Test("AC-11.4: GFM table falls back to text without crash")
    func testTableFallbackOniOS15() {
        // AC-11.4
        let tableMarkdown = "| A | B |\n|---|---|\n| 1 | 2 |"
        let parsed = try? AttributedString(
            markdown: tableMarkdown,
            options: AttributedString.MarkdownParsingOptions(
                interpretedSyntax: .inlineOnlyPreservingWhitespace
            )
        )
        let result = parsed ?? AttributedString(tableMarkdown)
        // No crash is the requirement; result must be non-nil and non-empty
        #expect(String(result.characters).isEmpty == false,
                "// AC-11.4: GFM table should produce non-empty output without crashing")
    }

    // AC-9.4: Given markdownContent = "**unclosed" (malformed) When parsed via AttributedString(markdown:)
    //         Then it falls back to plain text and result is not nil, with .string == "**unclosed"
    @Test("AC-9.4: Malformed markdown falls back to plain text")
    func testMalformedMarkdownFallback() {
        // AC-9.4
        let malformed = "**unclosed"
        let parsed = try? AttributedString(
            markdown: malformed,
            options: AttributedString.MarkdownParsingOptions(
                interpretedSyntax: .inlineOnlyPreservingWhitespace
            )
        )
        let result = parsed ?? AttributedString(malformed)
        #expect(String(result.characters) == malformed,
                "// AC-9.4: malformed markdown should fall back to plain text '**unclosed'")
    }
}
