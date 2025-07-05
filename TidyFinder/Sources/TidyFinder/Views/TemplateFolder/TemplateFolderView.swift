//
//  TemplateFolderView.swift
//  TidyFinder
//
//  Template folder workflow for applying folder settings to multiple folders
//

import SwiftUI
import TidyFinderCore

struct TemplateFolderView: View {
    @StateObject private var viewModel = TemplateFolderViewModel()
    @State private var hoveredButton: String? = nil
    @State private var showingAddFolderPanel = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Template Folder Section
                TemplateFolderSection(viewModel: viewModel)
                
                // Target Folders Section
                TargetFoldersSection(
                    viewModel: viewModel,
                    showingAddPanel: $showingAddFolderPanel
                )
                
                // Apply Settings Section
                ApplySettingsSection(
                    viewModel: viewModel,
                    hoveredButton: $hoveredButton
                )
            }
            .padding(20)
        }
        .fileImporter(
            isPresented: $showingAddFolderPanel,
            allowedContentTypes: [.folder],
            allowsMultipleSelection: true
        ) { result in
            switch result {
            case .success(let urls):
                viewModel.addTargetFolders(urls)
            case .failure(let error):
                viewModel.errorMessage = "Failed to add folders: \(error.localizedDescription)"
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("ApplyTemplateSettings"))) { _ in
            viewModel.applyTemplateSettings()
        }
    }
}

// MARK: - Template Folder Section

struct TemplateFolderSection: View {
    @ObservedObject var viewModel: TemplateFolderViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "folder.badge.questionmark")
                    .foregroundColor(.accentColor)
                Text("Template Folder")
                    .font(.headline)
            }
            
            Text("Select a folder to use as a template for view settings")
                .font(.caption)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 10) {
                if let templateURL = viewModel.templateFolderURL {
                    HStack {
                        Image(systemName: "folder.fill")
                            .foregroundColor(.accentColor)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(templateURL.lastPathComponent)
                                .font(.subheadline)
                                .lineLimit(1)
                            
                            Text(templateURL.path)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                                .truncationMode(.middle)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            viewModel.clearTemplateFolder()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .help("Remove template folder")
                    }
                    .padding(10)
                    .background(Color(NSColor.controlBackgroundColor))
                    .cornerRadius(6)
                } else {
                    Button(action: {
                        viewModel.selectTemplateFolder()
                    }) {
                        HStack {
                            Image(systemName: "folder.badge.plus")
                            Text("Select Template Folder")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .controlSize(.large)
                    .disabled(viewModel.isLoading)
                }
            }
        }
        .padding(16)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
    }
}

// MARK: - Target Folders Section

struct TargetFoldersSection: View {
    @ObservedObject var viewModel: TemplateFolderViewModel
    @Binding var showingAddPanel: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "folder.fill.badge.gearshape")
                    .foregroundColor(.accentColor)
                Text("Target Folders")
                    .font(.headline)
                
                Spacer()
                
                Button(action: {
                    showingAddPanel = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.accentColor)
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(viewModel.isLoading)
                .help("Add folders to apply settings to")
            }
            
            Text("Folders that will receive the template settings")
                .font(.caption)
                .foregroundColor(.secondary)
            
            if viewModel.targetFolderURLs.isEmpty {
                VStack {
                    Image(systemName: "folder.badge.plus")
                        .font(.largeTitle)
                        .foregroundColor(.secondary)
                    
                    Text("No target folders selected")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Button("Add Folders") {
                        showingAddPanel = true
                    }
                    .buttonStyle(.link)
                    .disabled(viewModel.isLoading)
                }
                .frame(maxWidth: .infinity)
                .padding(30)
                .background(Color(NSColor.controlBackgroundColor).opacity(0.5))
                .cornerRadius(6)
            } else {
                ScrollView {
                    VStack(spacing: 6) {
                        ForEach(viewModel.targetFolderURLs, id: \.self) { url in
                            TargetFolderRow(
                                url: url,
                                onRemove: {
                                    viewModel.removeTargetFolder(url)
                                }
                            )
                        }
                    }
                }
                .frame(maxHeight: 200)
                .background(Color(NSColor.controlBackgroundColor).opacity(0.5))
                .cornerRadius(6)
            }
        }
        .padding(16)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
    }
}

struct TargetFolderRow: View {
    let url: URL
    let onRemove: () -> Void
    @State private var isHovered = false
    
    var body: some View {
        HStack {
            Image(systemName: "folder.fill")
                .foregroundColor(.secondary)
                .font(.caption)
            
            VStack(alignment: .leading, spacing: 1) {
                Text(url.lastPathComponent)
                    .font(.caption)
                    .lineLimit(1)
                
                Text(url.path)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .truncationMode(.middle)
            }
            
            Spacer()
            
            if isHovered {
                Button(action: onRemove) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.red)
                        .font(.caption)
                }
                .buttonStyle(PlainButtonStyle())
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(isHovered ? Color(NSColor.selectedControlColor).opacity(0.1) : Color.clear)
        .cornerRadius(4)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovered = hovering
            }
        }
    }
}

// MARK: - Apply Settings Section

struct ApplySettingsSection: View {
    @ObservedObject var viewModel: TemplateFolderViewModel
    @Binding var hoveredButton: String?
    
    var body: some View {
        VStack(spacing: 12) {
            if viewModel.isLoading {
                ProgressSection(
                    progress: viewModel.progress,
                    currentFolder: viewModel.currentProcessingFolder,
                    totalFolders: viewModel.targetFolderURLs.count
                )
            }
            
            ActionButton(
                title: "Apply Template Settings",
                icon: "wand.and.stars",
                action: {
                    viewModel.applyTemplateSettings()
                },
                isProminent: true,
                isLoading: viewModel.isLoading,
                isHovered: hoveredButton == "apply",
                onHover: { hovering in
                    withAnimation(.easeInOut(duration: 0.15)) {
                        hoveredButton = hovering ? "apply" : nil
                    }
                },
                tooltip: "Copy view settings from template folder to all target folders"
            )
            .disabled(viewModel.templateFolderURL == nil || viewModel.targetFolderURLs.isEmpty)
            
            // Error message
            if let errorMessage = viewModel.errorMessage {
                ErrorMessageView(
                    message: errorMessage,
                    onRetry: nil,
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

struct ProgressSection: View {
    let progress: Double
    let currentFolder: String?
    let totalFolders: Int
    
    var body: some View {
        VStack(spacing: 8) {
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle())
            
            HStack {
                if let folder = currentFolder {
                    Text("Processing: \(folder)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                        .truncationMode(.middle)
                } else {
                    Text("Preparing...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text("\(Int(progress * Double(totalFolders)))/\(totalFolders)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(12)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(6)
    }
}

#Preview {
    TemplateFolderView()
        .frame(width: 600, height: 700)
}