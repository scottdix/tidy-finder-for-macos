import SwiftUI

struct IconViewPreview: View {
    @State private var selectedItem: String?
    @State private var hoveredItem: String?
    
    let items = [
        ("folder.fill", "Documents", true),
        ("folder.fill", "Downloads", true),
        ("folder.fill", "Pictures", true),
        ("doc.fill", "Report.pdf", false),
        ("photo.fill", "Vacation.jpg", false),
        ("doc.text.fill", "Notes.txt", false)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.adaptive(minimum: 50, maximum: 60), spacing: 8)
            ], spacing: 8) {
                ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                    VStack(spacing: 2) {
                        Image(systemName: item.0)
                            .font(.system(size: 28))
                            .foregroundColor(item.2 ? .blue : .gray)
                            .frame(width: 40, height: 40)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(
                                        selectedItem == item.1 ? Color.accentColor.opacity(0.3) :
                                        (hoveredItem == item.1 ? Color.gray.opacity(0.1) : Color.clear)
                                    )
                            )
                        
                        Text(item.1)
                            .font(.system(size: 9))
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                            .frame(width: 50)
                            .foregroundColor(selectedItem == item.1 ? .white : .primary)
                    }
                    .onTapGesture {
                        selectedItem = item.1
                    }
                    .onHover { hovering in
                        hoveredItem = hovering ? item.1 : nil
                    }
                }
            }
            .padding(8)
        }
    }
}

#Preview {
    IconViewPreview()
        .frame(width: 300, height: 200)
        .background(Color(NSColor.textBackgroundColor))
}