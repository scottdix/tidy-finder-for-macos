import SwiftUI

struct GalleryViewPreview: View {
    @State private var selectedItem: String?
    @State private var hoveredItem: String?
    
    let items = [
        (icon: "photo.fill", name: "Sunset.jpg", color: Color.orange),
        (icon: "photo.fill", name: "Beach.jpg", color: Color.blue),
        (icon: "photo.fill", name: "Mountain.jpg", color: Color.green),
        (icon: "doc.fill", name: "Report.pdf", color: Color.gray),
        (icon: "film.fill", name: "Video.mp4", color: Color.purple),
        (icon: "photo.fill", name: "Portrait.jpg", color: Color.pink)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.adaptive(minimum: 70, maximum: 80), spacing: 12)
            ], spacing: 12) {
                ForEach(items, id: \.name) { item in
                    VStack(spacing: 4) {
                        // Thumbnail
                        ZStack {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(item.color.opacity(0.2))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(
                                            selectedItem == item.name ? Color.accentColor :
                                            (hoveredItem == item.name ? Color.gray.opacity(0.3) : Color.clear),
                                            lineWidth: selectedItem == item.name ? 2 : 1
                                        )
                                )
                            
                            Image(systemName: item.icon)
                                .font(.system(size: 24))
                                .foregroundColor(item.color)
                        }
                        .frame(width: 70, height: 70)
                        .shadow(
                            color: Color.black.opacity(hoveredItem == item.name ? 0.15 : 0.05),
                            radius: hoveredItem == item.name ? 3 : 1,
                            y: 1
                        )
                        
                        Text(item.name)
                            .font(.system(size: 9))
                            .lineLimit(1)
                            .foregroundColor(selectedItem == item.name ? .accentColor : .primary)
                    }
                    .onTapGesture {
                        selectedItem = item.name
                    }
                    .onHover { hovering in
                        hoveredItem = hovering ? item.name : nil
                    }
                }
            }
            .padding(12)
        }
    }
}

#Preview {
    GalleryViewPreview()
        .frame(width: 300, height: 200)
        .background(Color(NSColor.textBackgroundColor))
}