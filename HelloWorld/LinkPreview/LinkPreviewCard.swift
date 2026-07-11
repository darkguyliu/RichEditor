import SwiftUI
import LinkPresentation

struct LinkPreviewCard: View {
    let preview: LinkPreview
    let onDismiss: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            // Site icon placeholder
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(red: 0.941, green: 0.941, blue: 0.941))
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: "link")
                        .font(.system(size: 20))
                        .foregroundColor(.secondary)
                )
            VStack(alignment: .leading, spacing: 2) {
                Text(preview.url.host ?? "")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                if let title = preview.title {
                    Text(title)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Color(red: 0.145, green: 0.141, blue: 0.141))
                        .lineLimit(2)
                } else {
                    Text(preview.url.absoluteString)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            Spacer()
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.secondary)
                    .padding(8)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Dismiss link preview")
        }
        .padding(10)
        .background(Color(.systemBackground))
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color(red: 0.878, green: 0.878, blue: 0.878), lineWidth: 1)
        )
        .cornerRadius(4)
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
    }
}
