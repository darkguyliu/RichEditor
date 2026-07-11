import SwiftUI

struct MentionTypeaheadOverlay: View {
    let candidates: [MentionCandidate]
    let onSelect: (MentionCandidate) -> Void

    var body: some View {
        VStack(spacing: 0) {
            Text("SUGGESTIONS")
                .font(.system(size: 11, weight: .bold))
                .tracking(0.5)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
            Divider()
            ForEach(candidates) { candidate in
                Button { onSelect(candidate) } label: {
                    HStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .fill(Color(red: 0.384, green: 0.392, blue: 0.655))
                                .frame(width: 30, height: 30)
                            Text(String(candidate.displayName.prefix(1)))
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        VStack(alignment: .leading, spacing: 1) {
                            Text(candidate.displayName)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color(red: 0.145, green: 0.141, blue: 0.141))
                            Text(candidate.role)
                                .font(.system(size: 12))
                                .foregroundColor(Color(red: 0.380, green: 0.380, blue: 0.380))
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }
                .buttonStyle(.plain)
                Divider().padding(.leading, 56)
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.08), radius: 8, y: -2)
    }
}
