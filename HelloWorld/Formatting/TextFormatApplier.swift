import UIKit

enum TextFormat {
    case bold, italic, inlineCode
}

struct TextFormatApplier {

    private static let boldKey = NSAttributedString.Key("com.helloworld.bold")
    private static let italicKey = NSAttributedString.Key("com.helloworld.italic")
    private static let inlineCodeKey = NSAttributedString.Key("com.helloworld.inlineCode")
    private static let defaultFontSize: CGFloat = 15

    /// Toggles the given format on the range in textStorage.
    /// If the entire range already has the format → remove it.
    /// If none or partial → apply it to the full range.
    func toggle(_ format: TextFormat, in storage: NSTextStorage, range: NSRange) {
        guard range.length > 0 else { return }

        if isFullyFormatted(format, in: storage, range: range) {
            removeFormat(format, in: storage, range: range)
        } else {
            applyFormat(format, in: storage, range: range)
        }
    }

    // MARK: - Private

    private func isFullyFormatted(_ format: TextFormat, in storage: NSTextStorage, range: NSRange) -> Bool {
        var allFormatted = true
        storage.enumerateAttributes(in: range, options: []) { attrs, _, stop in
            if !hasFormat(format, in: attrs) {
                allFormatted = false
                stop.pointee = true
            }
        }
        return allFormatted
    }

    private func hasFormat(_ format: TextFormat, in attrs: [NSAttributedString.Key: Any]) -> Bool {
        switch format {
        case .bold:
            return attrs[TextFormatApplier.boldKey] as? Bool == true
        case .italic:
            return attrs[TextFormatApplier.italicKey] as? Bool == true
        case .inlineCode:
            return attrs[TextFormatApplier.inlineCodeKey] as? Bool == true
        }
    }

    private func applyFormat(_ format: TextFormat, in storage: NSTextStorage, range: NSRange) {
        switch format {
        case .bold:
            storage.enumerateAttribute(.font, in: range, options: []) { value, subRange, _ in
                let font = (value as? UIFont) ?? UIFont.systemFont(ofSize: TextFormatApplier.defaultFontSize)
                let newFont = font.withTraitAdded(.traitBold)
                storage.addAttribute(.font, value: newFont, range: subRange)
            }
            storage.addAttribute(TextFormatApplier.boldKey, value: true, range: range)

        case .italic:
            storage.enumerateAttribute(.font, in: range, options: []) { value, subRange, _ in
                let font = (value as? UIFont) ?? UIFont.systemFont(ofSize: TextFormatApplier.defaultFontSize)
                let newFont = font.withTraitAdded(.traitItalic)
                storage.addAttribute(.font, value: newFont, range: subRange)
            }
            storage.addAttribute(TextFormatApplier.italicKey, value: true, range: range)

        case .inlineCode:
            storage.addAttribute(TextFormatApplier.inlineCodeKey, value: true, range: range)
        }
    }

    private func removeFormat(_ format: TextFormat, in storage: NSTextStorage, range: NSRange) {
        switch format {
        case .bold:
            storage.enumerateAttribute(.font, in: range, options: []) { value, subRange, _ in
                let font = (value as? UIFont) ?? UIFont.systemFont(ofSize: TextFormatApplier.defaultFontSize)
                let newFont = font.withTraitRemoved(.traitBold)
                storage.addAttribute(.font, value: newFont, range: subRange)
            }
            storage.removeAttribute(TextFormatApplier.boldKey, range: range)

        case .italic:
            storage.enumerateAttribute(.font, in: range, options: []) { value, subRange, _ in
                let font = (value as? UIFont) ?? UIFont.systemFont(ofSize: TextFormatApplier.defaultFontSize)
                let newFont = font.withTraitRemoved(.traitItalic)
                storage.addAttribute(.font, value: newFont, range: subRange)
            }
            storage.removeAttribute(TextFormatApplier.italicKey, range: range)

        case .inlineCode:
            storage.removeAttribute(TextFormatApplier.inlineCodeKey, range: range)
        }
    }
}

// MARK: - UIFont Helpers

private extension UIFont {
    func withTraitAdded(_ trait: UIFontDescriptor.SymbolicTraits) -> UIFont {
        let existingTraits = fontDescriptor.symbolicTraits
        let newTraits = existingTraits.union(trait)
        if let descriptor = fontDescriptor.withSymbolicTraits(newTraits) {
            return UIFont(descriptor: descriptor, size: pointSize)
        }
        return self
    }

    func withTraitRemoved(_ trait: UIFontDescriptor.SymbolicTraits) -> UIFont {
        let existingTraits = fontDescriptor.symbolicTraits
        let newTraits = existingTraits.subtracting(trait)
        if let descriptor = fontDescriptor.withSymbolicTraits(newTraits) {
            return UIFont(descriptor: descriptor, size: pointSize)
        }
        return self
    }
}
