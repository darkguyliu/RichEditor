import Foundation

/// Pure, stateless converter between NSAttributedString and Markdown text.
/// ZERO UIKit imports — must be testable without a host app.
struct MarkdownAttributedStringConverter {

    // MARK: - Custom Attribute Keys
    static let bulletListKey = NSAttributedString.Key("com.helloworld.bulletList")
    static let numberedListKey = NSAttributedString.Key("com.helloworld.numberedList")
    static let inlineCodeKey = NSAttributedString.Key("com.helloworld.inlineCode")
    static let codeBlockKey = NSAttributedString.Key("com.helloworld.codeBlock")
    static let blockquoteKey = NSAttributedString.Key("com.helloworld.blockquote")

    // MARK: - NSAttributedString → Markdown

    /// Converts an NSAttributedString to a Markdown string.
    /// Handles: bold (**text**), italic (_text_), bullet list (- item),
    /// numbered list (1. item), inline code (`text`), blockquote (> text).
    func toMarkdown(_ attributed: NSAttributedString) -> String {
        guard attributed.length > 0 else { return "" }

        var result = ""
        let string = attributed.string
        let paragraphs = string.components(separatedBy: "\n")
        var location = 0

        for (index, paragraph) in paragraphs.enumerated() {
            let paragraphLength = paragraph.utf16.count
            let paragraphRange = NSRange(location: location, length: paragraphLength)

            if paragraphRange.length == 0 {
                result += "\n"
                location += paragraphLength + 1
                continue
            }

            // Check paragraph-level attributes (use first character of paragraph)
            var isBullet = false
            var numberedIndex = 0
            var isBlockquote = false
            var isCodeBlock = false

            if paragraphRange.location < attributed.length {
                let checkRange = NSRange(location: paragraphRange.location, length: 1)
                attributed.enumerateAttributes(in: checkRange, options: []) { attrs, _, _ in
                    if attrs[MarkdownAttributedStringConverter.bulletListKey] as? Bool == true {
                        isBullet = true
                    }
                    if let num = attrs[MarkdownAttributedStringConverter.numberedListKey] as? Int {
                        numberedIndex = num
                    }
                    if attrs[MarkdownAttributedStringConverter.blockquoteKey] as? Bool == true {
                        isBlockquote = true
                    }
                    if attrs[MarkdownAttributedStringConverter.codeBlockKey] as? Bool == true {
                        isCodeBlock = true
                    }
                }
            }

            let linePrefix: String
            if isBullet {
                linePrefix = "- "
            } else if numberedIndex > 0 {
                linePrefix = "\(numberedIndex). "
            } else if isBlockquote {
                linePrefix = "> "
            } else {
                linePrefix = ""
            }

            if isCodeBlock {
                // Wrap in code fence
                result += "```\n\(paragraph)\n```"
            } else {
                // Build inline-formatted content for this paragraph
                var inlineResult = ""

                attributed.enumerateAttributes(in: paragraphRange, options: []) { attrs, range, _ in
                    let substring = (attributed.string as NSString).substring(with: range)
                    guard !substring.isEmpty else { return }

                    let isBold = isBoldAttribute(attrs)
                    let isItalic = isItalicAttribute(attrs)
                    let isCode = attrs[MarkdownAttributedStringConverter.inlineCodeKey] as? Bool == true

                    var text = substring
                    if isCode {
                        text = "`\(text)`"
                    } else {
                        if isBold && isItalic {
                            text = "***\(text)***"
                        } else if isBold {
                            text = "**\(text)**"
                        } else if isItalic {
                            text = "_\(text)_"
                        }
                    }
                    inlineResult += text
                }

                result += linePrefix + inlineResult
            }

            if index < paragraphs.count - 1 {
                result += "\n"
            }
            location += paragraphLength + 1
        }

        return result
    }

    // MARK: - Markdown → NSAttributedString

    /// Converts a Markdown string to NSAttributedString.
    /// Uses Foundation's AttributedString(markdown:) then bridges to NSAttributedString.
    /// Falls back to plain text if parsing fails.
    func toAttributedString(_ markdown: String) -> NSAttributedString {
        guard !markdown.isEmpty else { return NSAttributedString() }

        // Try AttributedString(markdown:) — available iOS 15+
        if let attrString = try? AttributedString(
            markdown: markdown,
            options: AttributedString.MarkdownParsingOptions(
                interpretedSyntax: .inlineOnlyPreservingWhitespace
            )
        ) {
            return NSAttributedString(attrString)
        }

        // Fallback: plain text
        return NSAttributedString(string: markdown)
    }

    // MARK: - Private Helpers

    private func isBoldAttribute(_ attrs: [NSAttributedString.Key: Any]) -> Bool {
        // On non-UIKit targets, font trait detection requires NSFont (macOS) or
        // checking for a font descriptor. We use the symbolic traits approach.
        // Since this file has zero UIKit imports, we check for the custom bold key
        // OR we check NSFont traits on macOS. On iOS this key is set by TextFormatApplier.
        return attrs[NSAttributedString.Key("com.helloworld.bold")] as? Bool == true
    }

    private func isItalicAttribute(_ attrs: [NSAttributedString.Key: Any]) -> Bool {
        return attrs[NSAttributedString.Key("com.helloworld.italic")] as? Bool == true
    }
}
