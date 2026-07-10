import Foundation

struct AnalyticsEvent {
    let name: String
    let properties: [String: Any]
}

enum AnalyticsLogger {
    static func track(_ event: AnalyticsEvent) {
        #if DEBUG
        print("[Analytics] \(event.name): \(event.properties)")
        #endif
    }
}
