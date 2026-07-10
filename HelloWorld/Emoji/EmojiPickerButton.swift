import SwiftUI
import UIKit

// Notification to tell RichTextEditorCoordinator to switch to emoji keyboard
extension NSNotification.Name {
    static let emojiPickerRequested = NSNotification.Name("com.helloworld.emojiPickerRequested")
}

struct EmojiPickerButton: View {
    var body: some View {
        Button {
            NotificationCenter.default.post(name: .emojiPickerRequested, object: nil)
        } label: {
            Text("😊")
                .font(.system(size: 18))
                .frame(width: 34, height: 34)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Insert emoji")
        .padding(.horizontal, 2)
    }
}
