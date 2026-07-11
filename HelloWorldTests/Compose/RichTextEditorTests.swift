import Testing
import Foundation
import UIKit
@testable import HelloWorld

@Suite("RichTextEditor")
struct RichTextEditorTests {

    // AC-5.1: Given a coordinator delegates to a UITextView
    //         When textViewDidChange is called with text "hello"
    //         Then viewModel.attributedContent.string == "hello"
    @Test("AC-5.1: Text change propagated to view model")
    @MainActor
    func testTextChangePropagatedToViewModel() async {
        // AC-5.1
        let viewModel = ComposeViewModel()
        let coordinator = RichTextEditorCoordinator(viewModel: viewModel)
        let textView = UITextView()
        textView.delegate = coordinator

        textView.text = "hello"
        coordinator.textViewDidChange(textView)

        // Allow the Task in textViewDidChange to execute
        await Task.yield()

        #expect(viewModel.attributedContent.string == "hello",
                "Expected viewModel.attributedContent.string to be 'hello', got: '\(viewModel.attributedContent.string)'")
    }

    // Regression: applyFormattingCallback must sync attributedContent so updateUIView
    // does NOT overwrite the formatted text on the next SwiftUI render pass (bold/italic revert bug).
    @Test("Regression: bold callback syncs attributedContent so formatting is not reverted")
    @MainActor
    func testFormattingCallbackSyncsAttributedContent() async {
        let viewModel = ComposeViewModel()
        let coordinator = RichTextEditorCoordinator(viewModel: viewModel)
        let textView = UITextView()
        coordinator.textView = textView
        coordinator.setupFormattingCallback()

        let boldText = NSMutableAttributedString(string: "hello world")
        textView.attributedText = boldText
        textView.selectedRange = NSRange(location: 0, length: 5) // select "hello"

        viewModel.applyFormattingCallback?(.bold)

        // After callback, viewModel.attributedContent must equal the textView's current attributed text.
        // If they are NOT equal, updateUIView would overwrite the UITextView and revert the bold.
        #expect(viewModel.attributedContent == textView.attributedText,
                "Expected attributedContent to match textView after bold applied — mismatch causes revert on next render")

        // Verify bold trait was actually applied to range 0..<5
        var hasBold = false
        viewModel.attributedContent.enumerateAttribute(.font, in: NSRange(location: 0, length: 5)) { value, _, _ in
            if let font = value as? UIFont, font.fontDescriptor.symbolicTraits.contains(.traitBold) {
                hasBold = true
            }
        }
        #expect(hasBold, "Expected bold trait in range 0..<5 after applying .bold format")
    }

    // Regression: toggleListCallback must be non-nil (list buttons were no-ops before this fix).
    @Test("Regression: toggleListCallback is set after setupFormattingCallback")
    @MainActor
    func testToggleListCallbackIsWired() async {
        let viewModel = ComposeViewModel()
        let coordinator = RichTextEditorCoordinator(viewModel: viewModel)
        let textView = UITextView()
        coordinator.textView = textView
        coordinator.setupFormattingCallback()

        #expect(viewModel.toggleListCallback != nil,
                "Expected toggleListCallback to be set — list buttons were no-ops without it")
    }

    // AC-5.3: Given a UITextView with bullet list text "apple"
    //         When Enter is pressed at the end of the text
    //         Then ListManager handles it (returns false) and textView has 2 paragraphs
    @Test("AC-5.3: Enter in bullet list continues the list")
    @MainActor
    func testEnterInBulletListContinues() async {
        // AC-5.3
        let viewModel = ComposeViewModel()
        let coordinator = RichTextEditorCoordinator(viewModel: viewModel)
        let textView = UITextView()
        textView.delegate = coordinator

        let bulletListKey = NSAttributedString.Key("com.helloworld.bulletList")
        let attrString = NSMutableAttributedString(string: "apple")
        attrString.addAttribute(bulletListKey, value: true, range: NSRange(location: 0, length: 5))
        textView.attributedText = attrString

        // Place cursor at end
        textView.selectedRange = NSRange(location: 5, length: 0)

        let result = coordinator.textView(
            textView,
            shouldChangeTextIn: NSRange(location: 5, length: 0),
            replacementText: "\n"
        )

        #expect(result == false, "Expected ListManager to handle the Enter key (return false)")

        let paragraphs = textView.text.components(separatedBy: "\n")
        #expect(paragraphs.count >= 2,
                "Expected at least 2 paragraphs after Enter in bullet list, got: \(paragraphs.count)")
    }
}
