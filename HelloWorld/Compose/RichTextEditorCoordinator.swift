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

        viewModel?.insertTableCallback = { [weak self] in
            guard let textView = self?.textView, let viewModel = self?.viewModel else { return }
            // Insert a 2×2 Markdown table template at the current cursor position.
            // Leading newline ensures the table starts on its own paragraph.
            let template = "\n| Header 1 | Header 2 |\n|---|---|\n| Cell | Cell |\n"
            textView.insertText(template)
            viewModel.attributedContent = textView.attributedText
        }

        viewModel?.insertMentionCallback = { [weak self] candidate in
            guard let self,
                  let textView = self.textView,
                  let viewModel = self.viewModel,
                  let query = viewModel.mentionQuery else { return }
            let cursor = textView.selectedRange.location
            // @query occupies (query.count + 1) characters ending at cursor
            let atPosition = cursor - query.count - 1
            guard atPosition >= 0 else { return }
            let replaceRange = NSRange(location: atPosition, length: query.count + 1)
            let replacement = "@\(candidate.displayName) "
            textView.textStorage.replaceCharacters(in: replaceRange, with: replacement)
            let newCursor = atPosition + replacement.count
            textView.selectedRange = NSRange(location: newCursor, length: 0)
            viewModel.mentionQuery = nil
            viewModel.attributedContent = textView.attributedText
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Emoji keyboard

    @objc private func switchToEmojiKeyboard() {
        guard let textView = textView else { return }
        if textView.inputView == nil {
            textView.inputView = makeEmojiInputView()
        } else {
            textView.inputView = nil   // toggle back to system keyboard
        }
        textView.becomeFirstResponder()
        textView.reloadInputViews()
    }

    private func makeEmojiInputView() -> UIView {
        let emojis: [String] = [
            "😀","😂","🥰","😎","🤔","😭","🎉","🔥","💯","👍","❤️","🙌",
            "😊","🤣","😅","😍","🤩","😜","🥳","💪","✅","⚡️","🚀","🌟",
            "😢","😤","🤯","🙏","👏","🫶"
        ]
        let height: CGFloat = 220
        let inputView = UIInputView(
            frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height),
            inputViewStyle: .keyboard
        )

        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsVerticalScrollIndicator = false
        inputView.addSubview(scroll)
        NSLayoutConstraint.activate([
            scroll.leadingAnchor.constraint(equalTo: inputView.leadingAnchor, constant: 8),
            scroll.trailingAnchor.constraint(equalTo: inputView.trailingAnchor, constant: -8),
            scroll.topAnchor.constraint(equalTo: inputView.topAnchor, constant: 8),
            scroll.bottomAnchor.constraint(equalTo: inputView.bottomAnchor, constant: -8)
        ])

        // 6-column grid
        let cols = 6
        let cellSize: CGFloat = 44
        let rows = Int(ceil(Double(emojis.count) / Double(cols)))
        let contentHeight = CGFloat(rows) * cellSize
        let contentWidth = CGFloat(cols) * cellSize

        scroll.contentSize = CGSize(width: contentWidth, height: contentHeight)

        for (i, emoji) in emojis.enumerated() {
            let col = i % cols
            let row = i / cols
            let btn = UIButton(type: .system)
            btn.setTitle(emoji, for: .normal)
            btn.titleLabel?.font = .systemFont(ofSize: 28)
            btn.frame = CGRect(x: CGFloat(col) * cellSize, y: CGFloat(row) * cellSize,
                               width: cellSize, height: cellSize)
            btn.addAction(UIAction { [weak self] _ in self?.insertEmoji(emoji) }, for: .touchUpInside)
            scroll.addSubview(btn)
        }
        return inputView
    }

    private func insertEmoji(_ emoji: String) {
        guard let textView = textView, let viewModel = viewModel else { return }
        textView.insertText(emoji)
        // Return to system keyboard
        textView.inputView = nil
        textView.reloadInputViews()
        viewModel.attributedContent = textView.attributedText
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
