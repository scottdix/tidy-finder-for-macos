//
//  ContentView.swift
//  TidyFinder
//
//  Created by generate_xcode_project.sh
//

import SwiftUI
import TidyFinderCore

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    @State private var showingSuccessAlert = false
    @State private var successMessage = ""
    @State private var hoveredButton: String? = nil
    @State private var selectedTab = "settings"
    @FocusState private var isWindowFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HeaderView()
            
            // Tab selection
            TabSelectionView(selectedTab: $selectedTab)
            
            // Main content
            Group {
                if selectedTab == "settings" {
                    MainContentView(
                        viewModel: viewModel,
                        hoveredButton: $hoveredButton
                    )
                } else if selectedTab == "template" {
                    TemplateFolderView()
                } else if selectedTab == "profiles" {
                    ProfilesView(contentViewModel: viewModel)
                }
            }
            
            // Footer
            FooterView()
        }
        .frame(minWidth: 600, maxWidth: 1000, minHeight: 780, maxHeight: 1000)
        .focused($isWindowFocused)
        .onAppear {
            isWindowFocused = true
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("RelaunchFinder"))) { _ in
            viewModel.relaunchFinder()
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("ApplyToAllFolders"))) { _ in
            viewModel.applyToAllExistingFolders()
        }
        .modifier(SettingsChangeHandler(viewModel: viewModel))
        .modifier(KeyboardShortcutHandler(viewModel: viewModel))
    }
}

// MARK: - Main Content View

struct MainContentView: View {
    @ObservedObject var viewModel: ContentViewModel
    @Binding var hoveredButton: String?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Default View Style Section
                ViewStyleSection(viewModel: viewModel)
                
                // Preview Gallery Section
                PreviewGalleryView(viewModel: viewModel)
                
                // Finder Options Section
                FinderOptionsSection(viewModel: viewModel)
                
                // Action Buttons
                ActionButtonsSection(
                    viewModel: viewModel,
                    hoveredButton: $hoveredButton
                )
            }
            .padding(20)
        }
    }
}

// MARK: - View Style Section

struct ViewStyleSection: View {
    @ObservedObject var viewModel: ContentViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "square.grid.2x2")
                    .foregroundColor(.accentColor)
                Text("Default View Style")
                    .font(.headline)
            }
            
            Text("Choose how folders display their contents by default")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Picker("View Style", selection: $viewModel.defaultViewStyle) {
                Label("Icon", systemImage: "square.grid.2x2").tag(FinderManager.ViewStyle.icon)
                Label("List", systemImage: "list.bullet").tag(FinderManager.ViewStyle.list)
                Label("Column", systemImage: "rectangle.split.3x1").tag(FinderManager.ViewStyle.column)
                Label("Gallery", systemImage: "square.grid.3x3").tag(FinderManager.ViewStyle.gallery)
            }
            .pickerStyle(SegmentedPickerStyle())
            .disabled(viewModel.isLoading)
            .help("Press 1-4 to quickly select a view style")
        }
        .padding(16)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
    }
}

// MARK: - Finder Options Section

struct FinderOptionsSection: View {
    @ObservedObject var viewModel: ContentViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "gearshape")
                    .foregroundColor(.accentColor)
                Text("Finder Options")
                    .font(.headline)
            }
            
            Text("Customize Finder's interface elements")
                .font(.caption)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 10) {
                ToggleRow(
                    title: "Show Path Bar",
                    icon: "point.topleft.down.curvedto.point.bottomright.up",
                    isOn: $viewModel.showPathBar,
                    isDisabled: viewModel.isLoading,
                    tooltip: "Displays the full path at the bottom of Finder windows"
                )
                
                ToggleRow(
                    title: "Show Status Bar",
                    icon: "info.circle",
                    isOn: $viewModel.showStatusBar,
                    isDisabled: viewModel.isLoading,
                    tooltip: "Shows item count and available space at the bottom"
                )
                
                ToggleRow(
                    title: "Show Sidebar",
                    icon: "sidebar.left",
                    isOn: $viewModel.showSidebar,
                    isDisabled: viewModel.isLoading,
                    tooltip: "Displays favorites and devices on the left side"
                )
                
                ToggleRow(
                    title: "Show Preview Pane",
                    icon: "sidebar.right",
                    isOn: $viewModel.showPreviewPane,
                    isDisabled: viewModel.isLoading,
                    tooltip: "Shows file previews on the right side"
                )
                
                ToggleRow(
                    title: "Show Toolbar",
                    icon: "toolbar",
                    isOn: $viewModel.showToolbar,
                    isDisabled: viewModel.isLoading,
                    tooltip: "Displays navigation and action buttons at the top"
                )
                
                ToggleRow(
                    title: "Show Tab Bar",
                    icon: "square.on.square",
                    isOn: $viewModel.showTabBar,
                    isDisabled: viewModel.isLoading,
                    tooltip: "Enables tabbed browsing in Finder windows"
                )
            }
        }
        .padding(16)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
    }
}

// MARK: - Action Buttons Section

struct ActionButtonsSection: View {
    @ObservedObject var viewModel: ContentViewModel
    @Binding var hoveredButton: String?
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                ActionButton(
                    title: "Relaunch Finder",
                    icon: "arrow.clockwise",
                    action: {
                        viewModel.relaunchFinder()
                    },
                    isProminent: true,
                    isLoading: viewModel.isLoading,
                    isHovered: hoveredButton == "relaunch",
                    onHover: { hovering in
                        withAnimation(.easeInOut(duration: 0.15)) {
                            hoveredButton = hovering ? "relaunch" : nil
                        }
                    },
                    tooltip: "Restart Finder to ensure all changes take effect (⌘R)"
                )
                .keyboardShortcut("r", modifiers: .command)
                
                ActionButton(
                    title: "Apply to All Folders",
                    icon: "folder.badge.gearshape",
                    action: {
                        viewModel.applyToAllExistingFolders()
                    },
                    isProminent: false,
                    isLoading: viewModel.isLoading,
                    isHovered: hoveredButton == "apply",
                    onHover: { hovering in
                        withAnimation(.easeInOut(duration: 0.15)) {
                            hoveredButton = hovering ? "apply" : nil
                        }
                    },
                    tooltip: "Reset all existing folder views to match current settings (⌘⇧A)"
                )
                .keyboardShortcut("a", modifiers: [.command, .shift])
            }
            
            // Loading indicator
            if viewModel.isLoading {
                LoadingIndicatorView(message: viewModel.loadingMessage)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
            
            // Error message
            if let errorMessage = viewModel.errorMessage {
                ErrorMessageView(
                    message: errorMessage,
                    onRetry: viewModel.retryLastAction,
                    onDismiss: { viewModel.errorMessage = nil }
                )
                .transition(.opacity.combined(with: .scale))
            }
            
            // Success message
            if viewModel.showSuccessMessage, let message = viewModel.successMessage {
                SuccessMessageView(message: message)
                    .transition(.opacity.combined(with: .scale))
            }
        }
    }
}

// MARK: - Loading Indicator View

struct LoadingIndicatorView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 8) {
            ProgressView()
                .progressViewStyle(LinearProgressViewStyle())
                .frame(maxWidth: .infinity)
                .scaleEffect(0.8)
            
            Text(message)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - View Modifiers

struct SettingsChangeHandler: ViewModifier {
    @ObservedObject var viewModel: ContentViewModel
    
    func body(content: Content) -> some View {
        content
            .onChange(of: viewModel.defaultViewStyle) { _ in
                viewModel.updateSettings()
            }
            .onChange(of: viewModel.showPathBar) { _ in
                viewModel.updateSettings()
            }
            .onChange(of: viewModel.showStatusBar) { _ in
                viewModel.updateSettings()
            }
            .onChange(of: viewModel.showSidebar) { _ in
                viewModel.updateSettings()
            }
            .onChange(of: viewModel.showPreviewPane) { _ in
                viewModel.updateSettings()
            }
            .onChange(of: viewModel.showToolbar) { _ in
                viewModel.updateSettings()
            }
            .onChange(of: viewModel.showTabBar) { _ in
                viewModel.updateSettings()
            }
    }
}

struct KeyboardShortcutHandler: ViewModifier {
    @ObservedObject var viewModel: ContentViewModel
    
    func body(content: Content) -> some View {
        // Note: onKeyPress is only available in macOS 12+
        // For macOS 11 compatibility, keyboard shortcuts are handled via
        // button keyboard shortcuts directly on the ActionButtons
        content
    }
}

struct HeaderView: View {
    @State private var iconRotation: Double = 0
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "folder.badge.gearshape")
                .font(.system(size: 52))
                .foregroundColor(.accentColor)
                .rotationEffect(.degrees(iconRotation))
                .onAppear {
                    withAnimation(.easeInOut(duration: 0.8)) {
                        iconRotation = 5
                    }
                }
            
            Text("TidyFinder")
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            Text("Organize your Finder with style")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(NSColor.controlBackgroundColor),
                    Color(NSColor.controlBackgroundColor).opacity(0.8)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

struct FooterView: View {
    var body: some View {
        HStack {
            HStack(spacing: 4) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.caption)
                Text("Changes are saved automatically")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                Button(action: {
                    NSWorkspace.shared.open(URL(string: "https://github.com/yourusername/tidyfinder")!)
                }) {
                    Label("Help", systemImage: "questionmark.circle")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .buttonStyle(PlainButtonStyle())
                .help("View documentation and support")
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(Color(NSColor.controlBackgroundColor))
    }
}

// MARK: - Tab Selection View

struct TabSelectionView: View {
    @Binding var selectedTab: String
    
    var body: some View {
        HStack(spacing: 0) {
            TabButton(
                title: "Settings",
                icon: "gearshape",
                isSelected: selectedTab == "settings",
                action: { selectedTab = "settings" }
            )
            
            TabButton(
                title: "Template Folder",
                icon: "folder.badge.questionmark",
                isSelected: selectedTab == "template",
                action: { selectedTab = "template" }
            )
            
            TabButton(
                title: "Profiles",
                icon: "person.2.badge.gearshape",
                isSelected: selectedTab == "profiles",
                action: { selectedTab = "profiles" }
            )
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
        .background(Color(NSColor.controlBackgroundColor).opacity(0.5))
    }
}

struct TabButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.subheadline)
                Text(title)
                    .font(.subheadline)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(isSelected ? Color.accentColor : Color.clear)
            )
            .foregroundColor(isSelected ? .white : .primary)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Custom UI Components

struct ToggleRow: View {
    let title: String
    let icon: String
    @Binding var isOn: Bool
    let isDisabled: Bool
    let tooltip: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.secondary)
                .frame(width: 20)
            
            Toggle(title, isOn: $isOn)
                .disabled(isDisabled)
        }
        .padding(.vertical, 2)
        .help(tooltip)
    }
}

// MARK: - Custom Button Styles for macOS 11 Compatibility

struct ProminentButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(isEnabled ? Color.accentColor : Color.gray.opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(configuration.isPressed ? Color.black.opacity(0.2) : Color.clear)
                    )
            )
            .foregroundColor(.white)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(NSColor.controlBackgroundColor))
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(configuration.isPressed ? Color.black.opacity(0.1) : Color.clear)
                    )
            )
            .foregroundColor(isEnabled ? .primary : .secondary)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
    }
}

// Type eraser for button styles
struct AnyButtonStyle: ButtonStyle {
    private let _makeBody: (Configuration) -> AnyView
    
    init<S: ButtonStyle>(_ style: S) {
        _makeBody = { configuration in
            AnyView(style.makeBody(configuration: configuration))
        }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        _makeBody(configuration)
    }
}

struct ActionButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    let isProminent: Bool
    let isLoading: Bool
    let isHovered: Bool
    let onHover: (Bool) -> Void
    let tooltip: String
    
    var body: some View {
        Button(action: action) {
            Label(title, systemImage: icon)
                .frame(maxWidth: .infinity)
                .scaleEffect(isHovered ? 1.02 : 1.0)
        }
        .controlSize(.large)
        .buttonStyle(isProminent ? AnyButtonStyle(ProminentButtonStyle()) : AnyButtonStyle(SecondaryButtonStyle()))
        .disabled(isLoading)
        .onHover(perform: onHover)
        .help(tooltip)
    }
}

struct ErrorMessageView: View {
    let message: String
    let onRetry: (() -> Void)?
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.red)
                    .font(.title3)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Error")
                        .font(.headline)
                        .foregroundColor(.red)
                    
                    Text(message)
                        .font(.caption)
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Spacer()
                
                Button(action: onDismiss) {
                    Image(systemName: "xmark")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            if let onRetry = onRetry {
                HStack {
                    Button("Try Again", action: onRetry)
                        .buttonStyle(.link)
                        .font(.caption)
                    
                    Text("•")
                        .foregroundColor(.secondary)
                        .font(.caption)
                    
                    Text("Check Finder permissions in System Settings")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(12)
        .background(Color.red.opacity(0.1))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.red.opacity(0.3), lineWidth: 1)
        )
    }
}

struct SuccessMessageView: View {
    let message: String
    
    var body: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
                .font(.title3)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding(12)
        .background(Color.green.opacity(0.1))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.green.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    ContentView()
}