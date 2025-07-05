import SwiftUI
import TidyFinderCore

struct PreviewGalleryView: View {
    @ObservedObject var viewModel: ContentViewModel
    @State private var hoveredPreview: FinderManager.ViewStyle?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "eye")
                    .foregroundColor(.accentColor)
                Text("Preview Gallery")
                    .font(.headline)
            }
            
            Text("Click a preview to select that view style")
                .font(.caption)
                .foregroundColor(.secondary)
            
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 16) {
                ForEach(FinderManager.ViewStyle.allCases, id: \.self) { style in
                    PreviewCard(
                        style: style,
                        isSelected: viewModel.defaultViewStyle == style,
                        isHovered: hoveredPreview == style,
                        action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                viewModel.defaultViewStyle = style
                            }
                        }
                    )
                    .onHover { hovering in
                        withAnimation(.easeInOut(duration: 0.15)) {
                            hoveredPreview = hovering ? style : nil
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
    }
}

struct PreviewCard: View {
    let style: FinderManager.ViewStyle
    let isSelected: Bool
    let isHovered: Bool
    let action: () -> Void
    
    private var previewView: AnyView {
        switch style {
        case .icon:
            return AnyView(IconViewPreview())
        case .list:
            return AnyView(ListViewPreview())
        case .column:
            return AnyView(ColumnViewPreview())
        case .gallery:
            return AnyView(GalleryViewPreview())
        }
    }
    
    private var styleIcon: String {
        switch style {
        case .icon:
            return "square.grid.2x2"
        case .list:
            return "list.bullet"
        case .column:
            return "rectangle.split.3x1"
        case .gallery:
            return "square.grid.3x3"
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Mini Finder window chrome
            HStack(spacing: 4) {
                Circle()
                    .fill(Color.red)
                    .frame(width: 6, height: 6)
                Circle()
                    .fill(Color.yellow)
                    .frame(width: 6, height: 6)
                Circle()
                    .fill(Color.green)
                    .frame(width: 6, height: 6)
                
                Spacer()
                
                Image(systemName: styleIcon)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                Text(style.displayName)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color(NSColor.windowBackgroundColor))
            
            Divider()
            
            // Preview content
            previewView
                .frame(height: 120)
                .frame(maxWidth: .infinity)
                .background(Color(NSColor.textBackgroundColor))
        }
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(
                    isSelected ? Color.accentColor : (isHovered ? Color.secondary.opacity(0.5) : Color.clear),
                    lineWidth: isSelected ? 2 : 1
                )
        )
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .shadow(
            color: Color.black.opacity(isHovered ? 0.15 : 0.1),
            radius: isHovered ? 4 : 2,
            x: 0,
            y: 2
        )
        .scaleEffect(isHovered ? 1.02 : 1.0)
        .onTapGesture(perform: action)
    }
}

#Preview {
    PreviewGalleryView(viewModel: ContentViewModel())
        .frame(width: 500)
}