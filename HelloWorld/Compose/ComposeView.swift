import SwiftUI

struct ComposeView: View {
    @ObservedObject var viewModel: ComposeViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var isAttachmentPickerPresented = false

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Quote block — visible when viewModel.quotedMessage != nil
                if let quoted = viewModel.quotedMessage {
                    QuoteBlockView(message: quoted) {
                        viewModel.quotedMessage = nil
                    }
                }
                // Attachment row — visible when attachments non-empty
                if !viewModel.attachments.isEmpty {
                    AttachmentRowView(attachments: $viewModel.attachments)
                }
                // Formatting toolbar
                FormattingToolbar(viewModel: viewModel)
                // Input row + Send button
                HStack(alignment: .bottom, spacing: 8) {
                    RichTextEditor(viewModel: viewModel)
                        .frame(minHeight: 38, maxHeight: 120)
                    Button {
                        isAttachmentPickerPresented = true
                    } label: {
                        Image(systemName: "paperclip")
                            .foregroundColor(.secondary)
                            .frame(width: 34, height: 34)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Attach file")
                    Button {
                        Task {
                            viewModel.submit()
                            dismiss()
                        }
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.white)
                            .frame(width: 36, height: 36)
                            .background(
                                Color(red: 0.384, green: 0.392, blue: 0.655) // #6264A7
                                    .opacity(viewModel.attributedContent.length == 0 ? 0.4 : 1.0)
                            )
                            .cornerRadius(8)
                    }
                    .disabled(viewModel.attributedContent.length == 0)
                    .accessibilityLabel("Send message")
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(.systemBackground))
            }
            .navigationTitle("New Message")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $isAttachmentPickerPresented) {
                AttachmentPicker(attachments: $viewModel.attachments)
            }
        }
    }
}

// MARK: - Stub views (replaced in Tasks 15 and 14 respectively)
struct QuoteBlockView: View {
    let message: RichMessage
    let onRemove: () -> Void
    var body: some View {
        HStack {
            Rectangle().fill(Color(red: 0.384, green: 0.392, blue: 0.655)).frame(width: 3)
            VStack(alignment: .leading, spacing: 2) {
                Text("Quoting").font(.caption).foregroundColor(Color(red: 0.384, green: 0.392, blue: 0.655))
                Text(message.markdownContent).font(.caption).foregroundColor(.secondary).lineLimit(2)
            }
            Spacer()
            Button(action: onRemove) { Image(systemName: "xmark").font(.caption) }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color(red: 0.961, green: 0.961, blue: 0.988))
    }
}

struct AttachmentRowView: View {
    @Binding var attachments: [MessageAttachment]
    @State private var isPickerPresented = false

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(attachments) { attachment in
                    AttachmentChip(attachment: attachment) {
                        attachments.removeAll { $0.id == attachment.id }
                    }
                }
            }
            .padding(.horizontal, 12)
        }
        .padding(.vertical, 4)
        .sheet(isPresented: $isPickerPresented) {
            AttachmentPicker(attachments: $attachments)
        }
    }
}
