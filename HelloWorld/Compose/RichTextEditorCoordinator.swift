import UIKit

final class RichTextEditorCoordinator: NSObject, UITextViewDelegate {
    weak var viewModel: ComposeViewModel?
    var listManager = ListManager()

    init(viewModel: ComposeViewModel) {
        self.viewModel = viewModel
    }

    func textViewDidChange(_ textView: UITextView) {
        Task { @MainActor in
            viewModel?.attributedContent = textView.attributedText
        }
        // @ mention detection
        let text = textView.text as NSString
        let cursor = textView.selectedRange.location
        if let query = MentionDetector().detectMentionQuery(in: text, cursorPosition: cursor) {
            Task { @MainActor in viewModel?.mentionQuery = query }
        } else {
            Task { @MainActor in viewModel?.mentionQuery = nil }
        }
    }

    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        // Intercept Enter key → route through ListManager
        if text == "\n" {
            if listManager.handleReturn(in: textView) {
                Task { @MainActor in
                    viewModel?.attributedContent = textView.attributedText
                }
                return false
            }
        }
        // Tab navigates between table cells (advance to next | position)
        if text == "\t" {
            // Minimal implementation: insert 4 spaces (table cells are pipe-separated)
            textView.insertText("    ")
            return false
        }
        // Detect @ for mention typeahead (future Task 12 — no-op for now)
        return true
    }
}
