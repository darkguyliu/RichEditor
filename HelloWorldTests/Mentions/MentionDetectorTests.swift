import Testing
@testable import HelloWorld

// AC-12.1
@Test("AC-12.1: Detects partial mention query after @")
func testDetectsPartialMentionQuery() {
    // AC-12.1
    let result = MentionDetector().detectMentionQuery(in: "hello @bo" as NSString, cursorPosition: 9)
    #expect(result == "bo")
}

// AC-12.2
@Test("AC-12.2: Mention ends at space")
func testMentionEndsAtSpace() {
    // AC-12.2
    let result = MentionDetector().detectMentionQuery(in: "hello @bob " as NSString, cursorPosition: 11)
    #expect(result == nil)
}

@Test("No @ sign returns nil")
func testNoAtSign() {
    let result = MentionDetector().detectMentionQuery(in: "hello world" as NSString, cursorPosition: 11)
    #expect(result == nil)
}
