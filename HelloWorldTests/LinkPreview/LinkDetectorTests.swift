import Testing
@testable import HelloWorld

@Suite("LinkDetector")
struct LinkDetectorTests {

    @Test("AC-16.1: Detects first URL in text")
    func testDetectsURL() {
        // AC-16.1
        let result = LinkDetector().firstURL(in: "Check out https://linear.app/team")
        #expect(result?.absoluteString == "https://linear.app/team",
                "Expected 'https://linear.app/team', got: '\(result?.absoluteString ?? "nil")'")
    }

    @Test("AC-16.2: Returns nil when no URL present")
    func testNoURLReturnsNil() {
        // AC-16.2
        let result = LinkDetector().firstURL(in: "Hello world")
        #expect(result == nil, "Expected nil when no URL is present, got: '\(result?.absoluteString ?? "nil")'")
    }
}
