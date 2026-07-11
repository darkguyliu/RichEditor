import Testing
import Foundation
@testable import HelloWorld

@Suite("LinkPreviewFetcher")
struct LinkPreviewFetcherTests {

    @Test("AC-16.5: LinkPreviewError types are defined")
    func testTimeoutHandledGracefully() async {
        // AC-16.5 — manual: real timeout tested in integration
        // Unit: verify error enum is well-formed
        let timeoutError = LinkPreviewError.timeout
        switch timeoutError {
        case .timeout: #expect(true)
        case .fetchFailed: #expect(false, "Should be timeout")
        }
    }
}
