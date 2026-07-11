import Foundation

struct RichMessage: Identifiable, Equatable {
    let id: UUID
    let markdownContent: String
    let attachments: [MessageAttachment]
    let quotedMessageId: UUID?
    let createdAt: Date
}

struct MessageAttachment: Identifiable, Equatable {
    let id: UUID
    let mimeType: String     // e.g. "application/pdf"
    let fileName: String     // display name only
    var temporaryURL: URL? = nil   // sandbox-scoped copy (asCopy:true); nil for inline content
}

enum ListStyle { case bullet, numbered }
