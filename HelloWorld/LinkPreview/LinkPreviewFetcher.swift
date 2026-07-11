import Foundation
import LinkPresentation

// @MainActor ensures LPMetadataProvider.startFetchingMetadata is called on the main thread,
// which is required by Apple's LinkPresentation framework.
@MainActor
final class LinkPreviewFetcher {
    func fetch(url: URL) async throws -> LinkPreview {
        let provider = LPMetadataProvider()
        provider.timeout = 3.0

        return try await withCheckedThrowingContinuation { continuation in
            provider.startFetchingMetadata(for: url) { metadata, error in
                if let error = error {
                    continuation.resume(throwing: LinkPreviewError.fetchFailed(error))
                    return
                }
                let preview = LinkPreview(
                    url: url,
                    title: metadata?.title,
                    description: nil
                )
                continuation.resume(returning: preview)
            }
        }
    }
}
