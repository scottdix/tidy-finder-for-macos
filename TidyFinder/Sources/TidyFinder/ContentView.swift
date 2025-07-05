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
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HeaderView()
            
            // Main content
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Default View Style Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Default View Style")
                            .font(.headline)
                        
                        Picker("View Style", selection: $viewModel.defaultViewStyle) {
                            Text("Icon View").tag(FinderManager.ViewStyle.icon)
                            Text("List View").tag(FinderManager.ViewStyle.list)
                            Text("Column View").tag(FinderManager.ViewStyle.column)
                            Text("Gallery View").tag(FinderManager.ViewStyle.gallery)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .disabled(viewModel.isLoading)
                    }
                    
                    Divider()
                    
                    // Finder Options Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Finder Options")
                            .font(.headline)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Toggle("Show Path Bar", isOn: $viewModel.showPathBar)
                                .disabled(viewModel.isLoading)
                            
                            Toggle("Show Status Bar", isOn: $viewModel.showStatusBar)
                                .disabled(viewModel.isLoading)
                            
                            Toggle("Show Sidebar", isOn: $viewModel.showSidebar)
                                .disabled(viewModel.isLoading)
                            
                            Toggle("Show Preview Pane", isOn: $viewModel.showPreviewPane)
                                .disabled(viewModel.isLoading)
                            
                            Toggle("Show Toolbar", isOn: $viewModel.showToolbar)
                                .disabled(viewModel.isLoading)
                            
                            Toggle("Show Tab Bar", isOn: $viewModel.showTabBar)
                                .disabled(viewModel.isLoading)
                        }
                    }
                    
                    Divider()
                    
                    // Action Buttons
                    VStack(spacing: 12) {
                        HStack(spacing: 12) {
                            Button(action: {
                                viewModel.relaunchFinder()
                            }) {
                                Label("Relaunch Finder", systemImage: "arrow.clockwise")
                                    .frame(maxWidth: .infinity)
                            }
                            .controlSize(.large)
                            .buttonStyle(.borderedProminent)
                            .disabled(viewModel.isLoading)
                            
                            Button(action: {
                                viewModel.applyToAllExistingFolders()
                            }) {
                                Label("Apply to All Folders", systemImage: "folder.badge.gearshape")
                                    .frame(maxWidth: .infinity)
                            }
                            .controlSize(.large)
                            .buttonStyle(.bordered)
                            .disabled(viewModel.isLoading)
                        }
                        
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(LinearProgressViewStyle())
                                .frame(maxWidth: .infinity)
                        }
                        
                        if let errorMessage = viewModel.errorMessage {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.red)
                                Text(errorMessage)
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(6)
                        }
                    }
                }
                .padding(20)
            }
            
            // Footer
            FooterView()
        }
        .frame(minWidth: 500, minHeight: 600)
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

struct HeaderView: View {
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "folder.badge.gearshape")
                .font(.system(size: 48))
                .foregroundColor(.accentColor)
            
            Text("TidyFinder")
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            Text("Customize your Finder settings")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
        .background(Color(NSColor.controlBackgroundColor))
    }
}

struct FooterView: View {
    var body: some View {
        HStack {
            Text("Changes are saved automatically")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Button(action: {
                NSWorkspace.shared.open(URL(string: "https://github.com/yourusername/tidyfinder")!)
            }) {
                Image(systemName: "questionmark.circle")
                    .foregroundColor(.secondary)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color(NSColor.controlBackgroundColor))
    }
}

#Preview {
    ContentView()
}