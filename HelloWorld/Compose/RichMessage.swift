import Foundation

struct RichMessage: Identifiable {
    let id: UUID
    let markdownContent: String
    let attachments: [MessageAttachment]
    let quotedMessageId: UUID?
    let createdAt: Date
}

struct MessageAttachment: Identifiable {
    let id: UUID
    let mimeType: String   // e.g. "application/pdf"
    let fileName: String   // display name only (no path)
}

enum ListStyle { case bullet, numbered }
