import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ComposeViewModel()
    @State private var isComposing = false

    var body: some View {
        NavigationView {
            FeedView(viewModel: viewModel)
                .navigationTitle("General")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            isComposing = true
                        } label: {
                            Image(systemName: "square.and.pencil")
                        }
                        .accessibilityLabel("Compose message")
                    }
                }
                .sheet(isPresented: $isComposing, onDismiss: {
                    // Clear quote if the sheet was dismissed without submitting
                    viewModel.quotedMessage = nil
                }) {
                    ComposeView(viewModel: viewModel)
                }
                // Auto-open compose when a message is quoted from the feed
                .onChange(of: viewModel.quotedMessage) { quoted in
                    if quoted != nil { isComposing = true }
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
