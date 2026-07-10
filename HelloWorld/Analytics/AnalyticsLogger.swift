import Foundation

struct AnalyticsEvent {
    let name: String
    let properties: [String: Any]
}

enum AnalyticsLogger {
    static func track(_ event: AnalyticsEvent) {
        // No-op stub — wired in a later task
    }
}
