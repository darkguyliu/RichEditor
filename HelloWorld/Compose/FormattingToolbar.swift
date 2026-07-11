import SwiftUI

// Teams purple #6264A7
private let toolbarAccent = Color(red: 0.384, green: 0.392, blue: 0.655)
// Active background #ebebf5
private let toolbarAccentLight = Color(red: 0.922, green: 0.922, blue: 0.961)

struct FormattingToolbar: View {
    @ObservedObject var viewModel: ComposeViewModel

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                FormatButton(icon: "bold", format: .bold, viewModel: viewModel)
                    .accessibilityLabel("Bold")
                FormatButton(icon: "italic", format: .italic, viewModel: viewModel)
                    .accessibilityLabel("Italic")
                ToolbarDivider()
                // Bullet list and Numbered list use custom action (not TextFormat enum — they're list styles)
                ListStyleButton(icon: "list.bullet", label: "Bullet list", style: .bullet, viewModel: viewModel)
                ListStyleButton(icon: "list.number", label: "Numbered list", style: .numbered, viewModel: viewModel)
                ToolbarDivider()
                FormatButton(icon: "chevron.left.slash.chevron.right", format: .inlineCode, viewModel: viewModel)
                    .accessibilityLabel("Code")
                // Table button is a special action, not a TextFormat
                Button {
                    // Insert 2x2 table template
                    // Stores pending action in viewModel for RichTextEditor to observe (Phase 2 stub)
                    viewModel.pendingTableInsert = true
                } label: {
                    Image(systemName: "tablecells")
                        .font(.system(size: 15, weight: .medium))
                        .frame(width: 34, height: 34)
                        .foregroundColor(.secondary)
                        .cornerRadius(4)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Insert table")
                .padding(.horizontal, 2)
                ToolbarDivider()
                EmojiPickerButton()
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 44)
        .background(Color(.systemBackground))
        .overlay(Divider(), alignment: .bottom)
    }
}

private struct FormatButton: View {
    let icon: String
    let format: TextFormat
    @ObservedObject var viewModel: ComposeViewModel

    private var isActive: Bool { viewModel.activeFormats.contains(format) }

    var body: some View {
        Button {
            // Delegates to the coordinator callback, which applies the format to the current
            // NSTextStorage selection (or toggles mark-ahead intent when nothing is selected).
            if let callback = viewModel.applyFormattingCallback {
                callback(format)
            } else {
                viewModel.activeFormats.toggle(format)
            }
        } label: {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .medium))
                .frame(width: 34, height: 34)
                .foregroundColor(isActive ? toolbarAccent : Color.secondary)
                .background(isActive ? toolbarAccentLight : Color.clear)
                .cornerRadius(4)
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 2)
    }
}

private struct ListStyleButton: View {
    let icon: String
    let label: String
    let style: ListStyle
    @ObservedObject var viewModel: ComposeViewModel

    var body: some View {
        Button {
            // No-op until ComposeView wires cursor paragraph (Task 8)
        } label: {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .medium))
                .frame(width: 34, height: 34)
                .foregroundColor(.secondary)
                .cornerRadius(4)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
        .padding(.horizontal, 2)
    }
}

private struct ToolbarDivider: View {
    var body: some View {
        Divider()
            .frame(height: 20)
            .padding(.horizontal, 4)
    }
}

extension Set where Element == TextFormat {
    mutating func toggle(_ element: Element) {
        if contains(element) { remove(element) } else { insert(element) }
    }
}
