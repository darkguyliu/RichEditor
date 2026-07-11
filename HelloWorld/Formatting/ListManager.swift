import UIKit

struct ListManager {

    // Called from UITextViewDelegate.textView(_:shouldChangeTextIn:replacementText:)
    // Returns true if it handled the Enter key (caller should return false to UITextView).
    // Inserts the next list item or exits the list.
    mutating func handleReturn(in textView: UITextView) -> Bool {
        let textStorage = textView.textStorage
        let cursorLocation = textView.selectedRange.location

        // Find the paragraph range containing the cursor
        let nsString = textStorage.string as NSString
        let paragraphRange = nsString.paragraphRange(for: NSRange(location: cursorLocation, length: 0))

        // Get attributes at the start of the paragraph
        guard paragraphRange.length > 0, paragraphRange.location < textStorage.length else {
            return false
        }

        let attrCheckLocation = paragraphRange.location < textStorage.length
            ? paragraphRange.location
            : max(0, textStorage.length - 1)

        guard textStorage.length > 0 else { return false }

        let attrs = textStorage.attributes(at: attrCheckLocation, effectiveRange: nil)

        let bulletListKey = NSAttributedString.Key("com.helloworld.bulletList")
        let numberedListKey = NSAttributedString.Key("com.helloworld.numberedList")

        if let isBullet = attrs[bulletListKey] as? Bool, isBullet {
            // Get content of this paragraph (excluding trailing newline)
            let paragraphText = nsString.substring(with: paragraphRange)
            let strippedContent = paragraphText
                .replacingOccurrences(of: "- ", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)

            if strippedContent.isEmpty {
                // Exit list: remove bullet attribute from current paragraph
                textStorage.removeAttribute(bulletListKey, range: paragraphRange)
                return true
            } else {
                // Continue list: insert newline with bullet attribute
                let insertionPoint = cursorLocation
                let newlineAttrs: [NSAttributedString.Key: Any] = [bulletListKey: true]
                textStorage.insert(
                    NSAttributedString(string: "\n", attributes: newlineAttrs),
                    at: insertionPoint
                )
                textView.selectedRange = NSRange(location: insertionPoint + 1, length: 0)
                return true
            }
        } else if let numberedIndex = attrs[numberedListKey] as? Int {
            // Get content of this paragraph
            let paragraphText = nsString.substring(with: paragraphRange)
            // Strip "N. " prefix to check if content is empty
            let strippedContent = paragraphText
                .replacingOccurrences(of: "^\\d+\\.\\s*", with: "", options: .regularExpression)
                .trimmingCharacters(in: .whitespacesAndNewlines)

            if strippedContent.isEmpty {
                // Exit list: remove numbered attribute from current paragraph
                textStorage.removeAttribute(numberedListKey, range: paragraphRange)
                return true
            } else {
                // Continue list: insert newline with incremented index
                let insertionPoint = cursorLocation
                let nextIndex = numberedIndex + 1
                let newlineAttrs: [NSAttributedString.Key: Any] = [numberedListKey: nextIndex]
                textStorage.insert(
                    NSAttributedString(string: "\n", attributes: newlineAttrs),
                    at: insertionPoint
                )
                textView.selectedRange = NSRange(location: insertionPoint + 1, length: 0)
                return true
            }
        }

        return false
    }

    // Starts a bullet list at the current paragraph.
    func startBulletList(in textStorage: NSTextStorage, at paragraph: NSRange) {
        let bulletListKey = NSAttributedString.Key("com.helloworld.bulletList")
        textStorage.addAttribute(bulletListKey, value: true, range: paragraph)
    }

    // Starts a numbered list at the current paragraph, index 1.
    func startNumberedList(in textStorage: NSTextStorage, at paragraph: NSRange) {
        let numberedListKey = NSAttributedString.Key("com.helloworld.numberedList")
        textStorage.addAttribute(numberedListKey, value: 1, range: paragraph)
    }
}
