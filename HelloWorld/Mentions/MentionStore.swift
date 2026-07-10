import Foundation

struct MentionStore {
    let candidates: [MentionCandidate] = [
        MentionCandidate(id: "alice", displayName: "Alice Chen", role: "PM"),
        MentionCandidate(id: "bob",   displayName: "Bob Park",   role: "iOS"),
        MentionCandidate(id: "carol", displayName: "Carol Díaz", role: "QA"),
    ]

    func search(_ query: String) -> [MentionCandidate] {
        if query.isEmpty { return candidates }
        return candidates.filter {
            $0.displayName.localizedCaseInsensitiveContains(query) ||
            $0.id.localizedCaseInsensitiveContains(query)
        }
    }
}
