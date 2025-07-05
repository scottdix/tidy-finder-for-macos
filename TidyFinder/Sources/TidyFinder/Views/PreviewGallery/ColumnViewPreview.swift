import SwiftUI

struct ColumnViewPreview: View {
    @State private var selectedColumn1: String? = "Documents"
    @State private var selectedColumn2: String? = "Projects"
    @State private var hoveredItem: (column: Int, item: String)?
    
    let column1Items = [
        ("folder.fill", "Applications"),
        ("folder.fill", "Desktop"),
        ("folder.fill", "Documents"),
        ("folder.fill", "Downloads")
    ]
    
    let column2Items = [
        ("folder.fill", "Projects"),
        ("folder.fill", "Archives"),
        ("doc.fill", "Resume.pdf"),
        ("doc.text.fill", "Notes.txt")
    ]
    
    let column3Items = [
        ("folder.fill", "TidyFinder"),
        ("folder.fill", "SwiftUI-Demo"),
        ("doc.fill", "README.md"),
        ("doc.text.fill", "TODO.txt")
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            // Column 1
            ColumnContent(
                items: column1Items,
                selectedItem: $selectedColumn1,
                hoveredItem: hoveredItem?.column == 1 ? hoveredItem?.item : nil,
                onHover: { item in
                    hoveredItem = item != nil ? (1, item!) : nil
                }
            )
            
            Divider()
            
            // Column 2
            ColumnContent(
                items: column2Items,
                selectedItem: $selectedColumn2,
                hoveredItem: hoveredItem?.column == 2 ? hoveredItem?.item : nil,
                onHover: { item in
                    hoveredItem = item != nil ? (2, item!) : nil
                }
            )
            
            Divider()
            
            // Column 3
            VStack(spacing: 0) {
                ForEach(column3Items, id: \.1) { item in
                    HStack(spacing: 4) {
                        Image(systemName: item.0)
                            .font(.system(size: 11))
                            .foregroundColor(item.0.contains("folder") ? .blue : .gray)
                        
                        Text(item.1)
                            .font(.system(size: 10))
                            .lineLimit(1)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(
                        hoveredItem?.column == 3 && hoveredItem?.item == item.1 ?
                        Color.gray.opacity(0.1) : Color.clear
                    )
                    .onHover { hovering in
                        hoveredItem = hovering ? (3, item.1) : nil
                    }
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct ColumnContent: View {
    let items: [(String, String)]
    @Binding var selectedItem: String?
    let hoveredItem: String?
    let onHover: (String?) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(items, id: \.1) { item in
                HStack(spacing: 4) {
                    Image(systemName: item.0)
                        .font(.system(size: 11))
                        .foregroundColor(.blue)
                    
                    Text(item.1)
                        .font(.system(size: 10))
                        .lineLimit(1)
                    
                    Spacer()
                    
                    if item.0.contains("folder") {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 8))
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(
                    selectedItem == item.1 ? Color.accentColor :
                    (hoveredItem == item.1 ? Color.gray.opacity(0.1) : Color.clear)
                )
                .foregroundColor(selectedItem == item.1 ? .white : .primary)
                .onTapGesture {
                    if item.0.contains("folder") {
                        selectedItem = item.1
                    }
                }
                .onHover { hovering in
                    onHover(hovering ? item.1 : nil)
                }
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ColumnViewPreview()
        .frame(width: 400, height: 200)
        .background(Color(NSColor.textBackgroundColor))
}