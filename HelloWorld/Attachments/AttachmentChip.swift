import SwiftUI

struct AttachmentChip: View {
    let attachment: MessageAttachment
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: iconName)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
            Text(attachment.fileName)
                .font(.system(size: 12))
                .foregroundColor(Color(red: 0.145, green: 0.141, blue: 0.141))
                .lineLimit(1)
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Remove \(attachment.fileName)")
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color(red: 0.961, green: 0.961, blue: 0.961))  // #f5f5f5
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color(red: 0.878, green: 0.878, blue: 0.878), lineWidth: 1)  // #e0e0e0
        )
        .cornerRadius(4)
    }

    private var iconName: String {
        switch attachment.mimeType {
        case _ where attachment.mimeType.hasPrefix("image/"): return "photo"
        case "application/pdf": return "doc.richtext"
        default: return "doc.fill"
        }
    }
}
