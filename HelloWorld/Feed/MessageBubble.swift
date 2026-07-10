import SwiftUI

struct MessageBubble: View {
    let message: RichMessage
    var onQuote: ((RichMessage) -> Void)? = nil  // optional — nil hides context menu

    private var attributedBody: AttributedString {
        (try? AttributedString(
            markdown: message.markdownContent,
            options: AttributedString.MarkdownParsingOptions(
                interpretedSyntax: .inlineOnlyPreservingWhitespace
            )
        )) ?? AttributedString(message.markdownContent)
    }

    private var initials: String {
        "ME"  // placeholder; real user name comes from auth (out of scope)
    }

    private var avatarColor: Color {
        Color(red: 0.384, green: 0.392, blue: 0.655) // Teams purple for "me" messages
    }

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            // Avatar — 30pt circle with initials
            ZStack {
                Circle()
                    .fill(avatarColor)
                    .frame(width: 30, height: 30)
                Text(initials)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.white)
            }
            VStack(alignment: .leading, spacing: 2) {
                // Author + timestamp header
                HStack(spacing: 6) {
                    Text("Me")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Color(red: 0.145, green: 0.141, blue: 0.141))
                    Text(message.createdAt, style: .time)
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 0.380, green: 0.380, blue: 0.380))
                }
                // Rendered Markdown body
                Text(attributedBody)
                    .font(.system(size: 15))
                    .foregroundColor(Color(red: 0.145, green: 0.141, blue: 0.141))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 6)
        .frame(maxWidth: .infinity, alignment: .leading)
        .contextMenu {
            if let onQuote {
                Button {
                    onQuote(message)
                } label: {
                    Label("Quote", systemImage: "quote.bubble")
                }
            }
        }
    }
}
