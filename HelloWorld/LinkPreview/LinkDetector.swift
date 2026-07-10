import Foundation

struct LinkPreview {
    let url: URL
    let title: String?
    let description: String?
}

enum LinkPreviewError: Error {
    case timeout
    case fetchFailed(Error)
}

struct LinkDetector {
    func firstURL(in text: String) -> URL? {
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            return nil
        }
        let range = NSRange(text.startIndex..., in: text)
        let matches = detector.matches(in: text, options: [], range: range)
        return matches.first?.url
    }
}
