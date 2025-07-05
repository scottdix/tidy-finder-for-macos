//
//  TemplateFolderViewModel.swift
//  TidyFinder
//
//  View model for template folder workflow
//

import Foundation
import SwiftUI
import AppKit
import TidyFinderCore

@MainActor
class TemplateFolderViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var templateFolderURL: URL?
    @Published var targetFolderURLs: [URL] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var showSuccessMessage: Bool = false
    @Published var progress: Double = 0.0
    @Published var currentProcessingFolder: String?
    
    // MARK: - Private Properties
    private let finderManager = FinderManager()
    private var successMessageTimer: Timer?
    
    // MARK: - Public Methods
    
    func selectTemplateFolder() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.title = "Select Template Folder"
        panel.message = "Choose a folder to use as a template for view settings"
        panel.prompt = "Select"
        
        panel.begin { [weak self] response in
            guard response == .OK, let url = panel.url else { return }
            
            Task { @MainActor in
                self?.templateFolderURL = url
            }
        }
    }
    
    func clearTemplateFolder() {
        templateFolderURL = nil
    }
    
    func addTargetFolders(_ urls: [URL]) {
        // Filter to only add folders that aren't already in the list
        let newFolders = urls.filter { url in
            !targetFolderURLs.contains(url) && url != templateFolderURL
        }
        
        targetFolderURLs.append(contentsOf: newFolders)
        
        // Sort by name for better organization
        targetFolderURLs.sort { $0.lastPathComponent < $1.lastPathComponent }
    }
    
    func removeTargetFolder(_ url: URL) {
        targetFolderURLs.removeAll { $0 == url }
    }
    
    func applyTemplateSettings() {
        guard let templateURL = templateFolderURL,
              !targetFolderURLs.isEmpty else {
            errorMessage = "Please select a template folder and at least one target folder"
            return
        }
        
        Task {
            isLoading = true
            errorMessage = nil
            progress = 0.0
            currentProcessingFolder = nil
            
            do {
                try await copyFolderViewSettings(from: templateURL, to: targetFolderURLs)
                
                isLoading = false
                showSuccess("Successfully applied template settings to \(targetFolderURLs.count) folder\(targetFolderURLs.count == 1 ? "" : "s")")
            } catch {
                isLoading = false
                showError("Failed to apply template settings", error: error)
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func copyFolderViewSettings(from templateURL: URL, to targetURLs: [URL]) async throws {
        // Process in batches for better progress tracking
        for (index, targetURL) in targetURLs.enumerated() {
            currentProcessingFolder = targetURL.lastPathComponent
            progress = Double(index) / Double(targetURLs.count)
            
            // Small delay to show progress
            try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        }
        
        // Use FinderManager to copy settings
        try finderManager.copyFolderViewSettings(from: templateURL, to: targetURLs)
        
        progress = 1.0
        currentProcessingFolder = nil
    }
    
    private func showSuccess(_ message: String) {
        successMessage = message
        showSuccessMessage = true
        
        // Cancel any existing timer
        successMessageTimer?.invalidate()
        
        // Hide success message after 3 seconds
        successMessageTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { [weak self] _ in
            withAnimation(.easeOut(duration: 0.3)) {
                self?.showSuccessMessage = false
            }
        }
    }
    
    private func showError(_ message: String, error: Error) {
        var detailedMessage = message
        
        if let finderError = error as? FinderManagerError {
            detailedMessage = finderError.localizedDescription
        } else if error.localizedDescription.contains("permission") {
            detailedMessage += ". Please check folder permissions in System Settings"
        } else {
            detailedMessage += ": \(error.localizedDescription)"
        }
        
        errorMessage = detailedMessage
    }
}