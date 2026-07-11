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
