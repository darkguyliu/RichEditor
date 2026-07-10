import Foundation

struct MentionCandidate: Identifiable {
    let id: String
    let displayName: String
    let role: String
}

struct MentionDetector {
    // Returns the query string after @ if cursor is inside an @-mention prefix,
    // or nil if the mention has been terminated (space, end of @-only, etc.)
    func detectMentionQuery(in text: NSString, cursorPosition: Int) -> String? {
        guard cursorPosition > 0, cursorPosition <= text.length else { return nil }
        var i = cursorPosition - 1
        while i >= 0 {
            let ch = text.character(at: i)
            if ch == UInt16(("@" as UnicodeScalar).value) {
                let start = i + 1
                let queryRange = NSRange(location: start, length: cursorPosition - start)
                let query = text.substring(with: queryRange)
                // Space terminates the mention
                if query.contains(" ") { return nil }
                return query
            }
            // If we hit whitespace before @, no mention in progress
            if ch == UInt16((" " as UnicodeScalar).value) || ch == UInt16(("\n" as UnicodeScalar).value) {
                return nil
            }
            i -= 1
        }
        return nil
    }
}
