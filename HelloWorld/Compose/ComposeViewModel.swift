import UIKit
import SwiftUI
import Combine

@MainActor
final class ComposeViewModel: ObservableObject {
    @Published var attributedContent: NSAttributedString = NSAttributedString()
    @Published var activeFormats: Set<TextFormat> = []
    @Published var attachments: [MessageAttachment] = []
    @Published var quotedMessage: RichMessage? = nil
    @Published var linkPreviews: [String] = []   // simplified: just URLs as strings for now
    @Published var mentionQuery: String? = nil
    @Published var messages: [RichMessage] = []   // the feed
    @Published var pendingTableInsert: Bool = false

    private let converter = MarkdownAttributedStringConverter()

    func applyFormatting(_ format: TextFormat, to textStorage: NSTextStorage, range: NSRange) {
        let applier = TextFormatApplier()
        applier.toggle(format, in: textStorage, range: range)
        // Update activeFormats based on whether bold/italic is present at range
        updateActiveFormats(in: textStorage, at: range)
    }

    func toggleList(_ style: ListStyle, in textStorage: NSTextStorage, cursorParagraph: NSRange) {
        switch style {
        case .bullet:
            ListManager().startBulletList(in: textStorage, at: cursorParagraph)
        case .numbered:
            ListManager().startNumberedList(in: textStorage, at: cursorParagraph)
        }
    }

    func submit() {
        var markdownContent = converter.toMarkdown(attributedContent)
        if let quoted = quotedMessage {
            let quotedText = String(quoted.markdownContent.prefix(80))
            markdownContent = "> \(quotedText)\n\n" + markdownContent
        }
        let msg = RichMessage(
            id: UUID(),
            markdownContent: markdownContent,
            attachments: attachments,
            quotedMessageId: quotedMessage?.id,
            createdAt: Date()
        )
        messages.append(msg)
        // Reset compose state
        attributedContent = NSAttributedString()
        attachments = []
        quotedMessage = nil
        linkPreviews = []
        activeFormats = []
    }

    func resolveMarkdown() -> String {
        return converter.toMarkdown(attributedContent)
    }

    private func updateActiveFormats(in textStorage: NSTextStorage, at range: NSRange) {
        guard range.length > 0, range.location < textStorage.length else { return }
        var isBold = false
        var isItalic = false
        textStorage.enumerateAttribute(.font, in: range, options: []) { value, _, _ in
            if let font = value as? UIFont {
                let traits = font.fontDescriptor.symbolicTraits
                if traits.contains(.traitBold) { isBold = true }
                if traits.contains(.traitItalic) { isItalic = true }
            }
        }
        if isBold { activeFormats.insert(.bold) } else { activeFormats.remove(.bold) }
        if isItalic { activeFormats.insert(.italic) } else { activeFormats.remove(.italic) }
    }
}
