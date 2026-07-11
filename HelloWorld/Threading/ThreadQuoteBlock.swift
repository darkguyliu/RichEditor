import SwiftUI

struct QuoteBlockView: View {
    let message: RichMessage
    let onRemove: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            // Left accent bar — Teams purple 2px
            Rectangle()
                .fill(Color(red: 0.384, green: 0.392, blue: 0.655))
                .frame(width: 2)
            VStack(alignment: .leading, spacing: 2) {
                Text("Quoting")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Color(red: 0.384, green: 0.392, blue: 0.655))
                Text(String(message.markdownContent.prefix(80)))
                    .font(.system(size: 13))
                    .foregroundColor(Color(red: 0.380, green: 0.380, blue: 0.380))
                    .lineLimit(2)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            Spacer()
            Button(action: onRemove) {
                Image(systemName: "xmark")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.secondary)
                    .padding(8)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Remove quote")
        }
        .background(Color(red: 0.961, green: 0.961, blue: 0.988))  // #f5f5fc
        .cornerRadius(4)
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
    }
}
