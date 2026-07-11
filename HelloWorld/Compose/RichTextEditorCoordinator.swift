import UIKit

final class RichTextEditorCoordinator: NSObject, UITextViewDelegate {
    weak var viewModel: ComposeViewModel?
    weak var textView: UITextView?
    var listManager = ListManager()

    init(viewModel: ComposeViewModel) {
        self.viewModel = viewModel
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(switchToEmojiKeyboard),
            name: .emojiPickerRequested, object: nil)
    }

    /// Call from RichTextEditor.makeUIView after setting self.textView.
    func setupFormattingCallback() {
        viewModel?.applyFormattingCallback = { [weak self] format in
            guard let self, let textView = self.textView, let viewModel = self.viewModel else { return }
            let range = textView.selectedRange
            if range.length > 0 {
                viewModel.applyFormatting(format, to: textView.textStorage, range: range)
                // Sync viewModel.attributedContent immediately so updateUIView's equality check
                // does NOT overwrite the just-applied formatting on the next SwiftUI render pass.
                viewModel.attributedContent = textView.attributedText
            } else {
                // No selection: toggle mark-ahead intent so the next typed char uses the format
                viewModel.activeFormats.toggle(format)
            }
        }

        viewModel?.toggleListCallback = { [weak self] style in
            guard let self, let textView = self.textView, let viewModel = self.viewModel else { return }
            let nsString = textView.text as NSString
            let paragraphRange = nsString.paragraphRange(for: textView.selectedRange)
            viewModel.toggleList(style, in: textView.textStorage, cursorParagraph: paragraphRange)
            viewModel.attributedContent = textView.attributedText
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func switchToEmojiKeyboard() {
        // Switch UITextView keyboard to emoji
        // Will be wired to the actual UITextView in Task 13 via a stored reference
        // For now: the notification fires; emoji keyboard integration is manual
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
