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
                .sheet(isPresented: $isComposing) {
                    ComposeView(viewModel: viewModel)
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
