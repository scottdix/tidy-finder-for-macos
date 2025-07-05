import SwiftUI

struct ListViewPreview: View {
    @State private var selectedItem: String?
    @State private var hoveredItem: String?
    
    let items = [
        (icon: "folder.fill", name: "Documents", date: "Today", size: "--", isFolder: true),
        (icon: "folder.fill", name: "Downloads", date: "Yesterday", size: "--", isFolder: true),
        (icon: "folder.fill", name: "Pictures", date: "Dec 20", size: "--", isFolder: true),
        (icon: "doc.fill", name: "Report.pdf", date: "Dec 18", size: "2.3 MB", isFolder: false),
        (icon: "photo.fill", name: "Vacation.jpg", date: "Dec 15", size: "4.1 MB", isFolder: false),
        (icon: "doc.text.fill", name: "Notes.txt", date: "Dec 10", size: "12 KB", isFolder: false)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack(spacing: 0) {
                Text("Name")
                    .font(.system(size: 9, weight: .medium))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Date Modified")
                    .font(.system(size: 9, weight: .medium))
                    .foregroundColor(.secondary)
                    .frame(width: 60, alignment: .leading)
                
                Text("Size")
                    .font(.system(size: 9, weight: .medium))
                    .foregroundColor(.secondary)
                    .frame(width: 40, alignment: .trailing)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
            .background(Color(NSColor.controlBackgroundColor))
            
            Divider()
            
            // List items
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(items, id: \.name) { item in
                        HStack(spacing: 4) {
                            Image(systemName: item.icon)
                                .font(.system(size: 12))
                                .foregroundColor(item.isFolder ? .blue : .gray)
                                .frame(width: 16)
                            
                            Text(item.name)
                                .font(.system(size: 10))
                                .lineLimit(1)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text(item.date)
                                .font(.system(size: 9))
                                .foregroundColor(.secondary)
                                .frame(width: 60, alignment: .leading)
                            
                            Text(item.size)
                                .font(.system(size: 9))
                                .foregroundColor(.secondary)
                                .frame(width: 40, alignment: .trailing)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(
                            selectedItem == item.name ? Color.accentColor :
                            (hoveredItem == item.name ? Color.gray.opacity(0.1) : Color.clear)
                        )
                        .foregroundColor(selectedItem == item.name ? .white : .primary)
                        .onTapGesture {
                            selectedItem = item.name
                        }
                        .onHover { hovering in
                            hoveredItem = hovering ? item.name : nil
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ListViewPreview()
        .frame(width: 300, height: 200)
        .background(Color(NSColor.textBackgroundColor))
}