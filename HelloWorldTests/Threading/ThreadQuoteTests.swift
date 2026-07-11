import Testing
import Foundation
import UIKit
@testable import HelloWorld

@Suite("ThreadQuote")
struct ThreadQuoteTests {

    // AC-15.2: Given quotedMessage is set When it is cleared Then quotedMessage is nil
    @Test("AC-15.2: Remove quote clears quotedMessage")
    @MainActor
    func testRemoveQuote() async {
        // AC-15.2
        let vm = ComposeViewModel()
        vm.quotedMessage = RichMessage(
            id: UUID(),
            markdownContent: "hello",
            attachments: [],
            quotedMessageId: nil,
            createdAt: Date()
        )
        vm.quotedMessage = nil
        #expect(vm.quotedMessage == nil)
    }

    // AC-15.3: Given quotedMessage is set When submit() is called Then the new message's
    //          markdownContent starts with the blockquote prefix
    @Test("AC-15.3: Quote is prepended to markdown on submit")
    @MainActor
    func testQuoteIncludedInMarkdown() async {
        // AC-15.3
        let vm = ComposeViewModel()
        vm.quotedMessage = RichMessage(
            id: UUID(),
            markdownContent: "quoted text",
            attachments: [],
            quotedMessageId: nil,
            createdAt: Date()
        )
        vm.attributedContent = NSAttributedString(string: "reply text")
        vm.submit()
        #expect(vm.messages.last?.markdownContent.hasPrefix("> quoted text") == true)
    }
}
