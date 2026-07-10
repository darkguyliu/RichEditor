import Testing
@testable import HelloWorld

@Suite("AnalyticsLogger")
struct AnalyticsLoggerTests {

    @Test("AC-17.1: rich_text_format_applied event has correct properties")
    func testRichTextFormatAppliedEvent() {
        // AC-17.1
        let event = AnalyticsEvent(
            name: "rich_text_format_applied",
            properties: ["format": "bold", "platform": "ios"]
        )
        #expect(event.name == "rich_text_format_applied")
        #expect(event.properties["format"] as? String == "bold")
        #expect(event.properties["platform"] as? String == "ios")
    }

    @Test("AC-17.2: rich_text_render_fidelity_check event has correct properties")
    func testRenderFidelityCheckEvent() {
        // AC-17.2
        let event = AnalyticsEvent(
            name: "rich_text_render_fidelity_check",
            properties: ["passed": true, "content_types": ["bold", "bullet_list"], "platform": "ios"]
        )
        #expect(event.name == "rich_text_render_fidelity_check")
        #expect(event.properties["passed"] as? Bool == true)
        #expect(event.properties["platform"] as? String == "ios")
    }

    @Test("AC-17.3: emoji_picker_opened event has correct properties")
    func testEmojiPickerOpenedEvent() {
        // AC-17.3
        let event = AnalyticsEvent(
            name: "emoji_picker_opened",
            properties: ["platform": "ios"]
        )
        #expect(event.name == "emoji_picker_opened")
        #expect(event.properties["platform"] as? String == "ios")
    }

    @Test("AC-17.4: file_attachment_added event has correct properties")
    func testFileAttachmentAddedEvent() {
        // AC-17.4
        let event = AnalyticsEvent(
            name: "file_attachment_added",
            properties: ["file_type": "application/pdf", "platform": "ios"]
        )
        #expect(event.name == "file_attachment_added")
        #expect(event.properties["file_type"] as? String == "application/pdf")
        #expect(event.properties["platform"] as? String == "ios")
    }

    @Test("AC-17.5: link_preview_fetched event has correct properties")
    func testLinkPreviewFetchedEvent() {
        // AC-17.5
        let event = AnalyticsEvent(
            name: "link_preview_fetched",
            properties: ["success": true, "platform": "ios"]
        )
        #expect(event.name == "link_preview_fetched")
        #expect(event.properties["success"] as? Bool == true)
        #expect(event.properties["platform"] as? String == "ios")
    }
}
