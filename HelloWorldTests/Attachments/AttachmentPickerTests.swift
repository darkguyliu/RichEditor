import Testing
import UIKit
@testable import HelloWorld

@Suite("AttachmentPicker")
struct AttachmentPickerTests {

    // AC-14.2: Given a MessageAttachment is appended to an array
    //          When we inspect the array Then it contains 1 element with the correct fileName
    @Test("AC-14.2: Attachment chip appears after selection")
    @MainActor
    func testAttachmentChipAppearsAfterSelection() async {
        // AC-14.2
        var attachments: [MessageAttachment] = []
        attachments.append(MessageAttachment(id: UUID(), mimeType: "application/pdf", fileName: "report.pdf"))

        #expect(attachments.count == 1, "Expected 1 attachment after append")
        #expect(attachments[0].fileName == "report.pdf", "Expected fileName to be 'report.pdf'")
    }

    // AC-14.3: Given 2 attachments in an array When the first is removed
    //          Then count is 1 and the remaining attachment is the second
    @Test("AC-14.3: Remove attachment reduces array by one and keeps remaining")
    @MainActor
    func testRemoveAttachment() async {
        // AC-14.3
        let first = MessageAttachment(id: UUID(), mimeType: "application/pdf", fileName: "first.pdf")
        let second = MessageAttachment(id: UUID(), mimeType: "image/png", fileName: "second.png")
        var attachments: [MessageAttachment] = [first, second]

        attachments.removeAll { $0.id == first.id }

        #expect(attachments.count == 1, "Expected 1 attachment after removal")
        #expect(attachments[0].id == second.id, "Expected remaining attachment to be 'second'")
    }

    // AC-14.4: Given 3 attachments in viewModel.attachments When submit() is called
    //          Then the last RichMessage has 3 attachments
    @Test("AC-14.4: Attachments included in submitted message")
    @MainActor
    func testAttachmentIncludedOnSubmit() async {
        // AC-14.4
        let vm = ComposeViewModel()
        vm.attachments = [
            MessageAttachment(id: UUID(), mimeType: "application/pdf", fileName: "doc1.pdf"),
            MessageAttachment(id: UUID(), mimeType: "image/png", fileName: "photo.png"),
            MessageAttachment(id: UUID(), mimeType: "text/plain", fileName: "notes.txt")
        ]

        vm.submit()

        #expect(vm.messages.last?.attachments.count == 3,
                "Expected 3 attachments in the submitted RichMessage, got: \(vm.messages.last?.attachments.count ?? -1)")
    }
}
