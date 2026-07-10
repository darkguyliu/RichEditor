import SwiftUI
import UniformTypeIdentifiers

struct AttachmentPicker: UIViewControllerRepresentable {
    @Binding var attachments: [MessageAttachment]
    @Environment(\.dismiss) private var dismiss

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.item], asCopy: true)
        picker.delegate = context.coordinator
        picker.allowsMultipleSelection = false
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    func makeCoordinator() -> AttachmentPickerCoordinator {
        AttachmentPickerCoordinator(attachments: $attachments)
    }
}

final class AttachmentPickerCoordinator: NSObject, UIDocumentPickerDelegate {
    @Binding var attachments: [MessageAttachment]

    init(attachments: Binding<[MessageAttachment]>) {
        self._attachments = attachments
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        // Resolve MIME type from file extension
        let mimeType = mimeTypeForURL(url)
        let attachment = MessageAttachment(
            id: UUID(),
            mimeType: mimeType,
            fileName: url.lastPathComponent
        )
        DispatchQueue.main.async { [weak self] in
            self?.attachments.append(attachment)
            // Emit analytics (Task 17 wires this)
            AnalyticsLogger.track(AnalyticsEvent(
                name: "file_attachment_added",
                properties: ["file_type": mimeType, "platform": "ios"]
            ))
        }
    }

    private func mimeTypeForURL(_ url: URL) -> String {
        if let uti = UTType(filenameExtension: url.pathExtension),
           let mimeType = uti.preferredMIMEType {
            return mimeType
        }
        return "application/octet-stream"
    }
}
