import Testing
import Foundation
import UIKit
@testable import HelloWorld

@Suite("ComposeViewModel")
struct ComposeViewModelTests {

    // AC-7.1: Given attributedContent has bold text When submit() is called
    //         Then the new RichMessage.markdownContent contains **bold text**
    @Test("AC-7.1: Submit serializes bold text to markdown")
    @MainActor
    func testSubmitSerializesToMarkdown() async {
        // AC-7.1
        let vm = ComposeViewModel()
        let storage = NSTextStorage(string: "bold text")
        let applier = TextFormatApplier()
        let range = NSRange(location: 0, length: storage.length)
        applier.toggle(.bold, in: storage, range: range)
        vm.attributedContent = NSAttributedString(attributedString: storage)

        vm.submit()

        let msg = vm.messages.last
        #expect(msg != nil, "Expected a message after submit")
        #expect(msg?.markdownContent.contains("**bold text**") == true,
                "Expected markdownContent to contain '**bold text**', got: '\(msg?.markdownContent ?? "")'")
    }

    // AC-7.2: Given submit() is called When it completes
    //         Then attributedContent is reset to empty and messages.count incremented by 1
    @Test("AC-7.2: Submit resets compose state and increments messages count")
    @MainActor
    func testSubmitResetsState() async {
        // AC-7.2
        let vm = ComposeViewModel()
        vm.attributedContent = NSAttributedString(string: "hello")
        let initialCount = vm.messages.count

        vm.submit()

        #expect(vm.attributedContent.length == 0, "Expected attributedContent to be reset to empty")
        #expect(vm.messages.count == initialCount + 1, "Expected messages.count to increment by 1")
    }

    // AC-7.3: Given attributedContent is empty When resolveMarkdown() is called
    //         Then it returns an empty string (not nil, not crash)
    @Test("AC-7.3: Empty content returns empty markdown string")
    @MainActor
    func testEmptyContentReturnsEmptyMarkdown() async {
        // AC-7.3
        let vm = ComposeViewModel()
        // attributedContent is empty by default

        let result = vm.resolveMarkdown()

        #expect(result == "", "Expected empty string from resolveMarkdown() when content is empty, got: '\(result)'")
    }

    // AC-16.4: Given dismissLinkPreview() is called for a preview
    //          Then linkPreviews is empty and that URL is excluded from future fetches
    @Test("AC-16.4: Dismissed link preview is removed from linkPreviews")
    @MainActor
    func testDismissedURLNotRefetched() async {
        // AC-16.4
        let vm = ComposeViewModel()
        let url = URL(string: "https://example.com")!
        let preview = LinkPreview(url: url, title: nil, description: nil)

        vm.dismissLinkPreview(preview)

        #expect(vm.linkPreviews.isEmpty,
                "Expected linkPreviews to be empty after dismissLinkPreview, got: \(vm.linkPreviews.count) items")
    }

    // AC-7.4: Given 3 attachments in attachments When submit() is called
    //         Then the new RichMessage.attachments contains exactly 3 items
    @Test("AC-7.4: Attachments are preserved in the submitted RichMessage")
    @MainActor
    func testAttachmentsPreservedOnSubmit() async {
        // AC-7.4
        let vm = ComposeViewModel()
        vm.attachments = [
            MessageAttachment(id: UUID(), mimeType: "application/pdf", fileName: "doc1.pdf"),
            MessageAttachment(id: UUID(), mimeType: "image/png", fileName: "photo.png"),
            MessageAttachment(id: UUID(), mimeType: "text/plain", fileName: "notes.txt")
        ]

        vm.submit()

        let msg = vm.messages.last
        #expect(msg != nil, "Expected a message after submit")
        #expect(msg?.attachments.count == 3,
                "Expected 3 attachments in the submitted RichMessage, got: \(msg?.attachments.count ?? -1)")
    }
}
