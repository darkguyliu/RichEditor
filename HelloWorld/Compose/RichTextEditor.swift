import SwiftUI
import UIKit

struct RichTextEditor: UIViewRepresentable {
    @ObservedObject var viewModel: ComposeViewModel

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.allowsEditingTextAttributes = true
        textView.isScrollEnabled = false
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.adjustsFontForContentSizeCategory = true
        textView.backgroundColor = .clear
        textView.textContainerInset = UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 0)
        // Wire the coordinator's textView reference so toolbar buttons can reach NSTextStorage.
        context.coordinator.textView = textView
        context.coordinator.setupFormattingCallback()
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        // Only update if the content actually changed (avoid cursor jumping)
        if uiView.attributedText != viewModel.attributedContent {
            uiView.attributedText = viewModel.attributedContent
        }
    }

    func makeCoordinator() -> RichTextEditorCoordinator {
        RichTextEditorCoordinator(viewModel: viewModel)
    }
}
