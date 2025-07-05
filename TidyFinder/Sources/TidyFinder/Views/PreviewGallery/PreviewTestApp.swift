import SwiftUI

// Test app to verify preview components
struct PreviewTestApp: App {
    var body: some Scene {
        WindowGroup {
            TestContentView()
        }
    }
}

struct TestContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("TidyFinder Preview Gallery Test")
                .font(.largeTitle)
                .padding()
            
            PreviewGalleryView(viewModel: viewModel)
                .padding()
            
            Text("Selected: \(viewModel.defaultViewStyle.displayName)")
                .font(.headline)
        }
        .frame(width: 700, height: 600)
    }
}

#Preview {
    TestContentView()
}