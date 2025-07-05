import Foundation
import SwiftUI
import TidyFinderCore

@MainActor
class ContentViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var defaultViewStyle: FinderManager.ViewStyle = .list
    @Published var showPathBar: Bool = false
    @Published var showStatusBar: Bool = false
    @Published var showSidebar: Bool = true
    @Published var showPreviewPane: Bool = false
    @Published var showToolbar: Bool = true
    @Published var showTabBar: Bool = true
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var showSuccessMessage: Bool = false
    @Published var loadingMessage: String = "Processing..."
    
    // MARK: - Private Properties
    private let finderManager = FinderManager()
    private var lastAction: (() -> Void)?
    private var successMessageTimer: Timer?
    
    // MARK: - Initialization
    init() {
        loadCurrentSettings()
    }
    
    // MARK: - Public Methods
    func loadCurrentSettings() {
        Task {
            isLoading = true
            errorMessage = nil
            loadingMessage = "Loading current settings..."
            
            // Get current settings directly from FinderManager
            
            // Update UI state with current settings
            if let viewStyle = finderManager.getCurrentViewStyle() {
                self.defaultViewStyle = viewStyle
            }
            self.showPathBar = finderManager.getOptionValue(.showPathBar)
            self.showStatusBar = finderManager.getOptionValue(.showStatusBar)
            self.showSidebar = finderManager.getOptionValue(.showSidebar)
            self.showPreviewPane = finderManager.getOptionValue(.showPreviewPane)
            // Note: showToolbar and showTabBar are not available in FinderManager
            // These may need to be implemented separately or removed
            
            isLoading = false
        }
    }
    
    func updateSettings() {
        Task {
            lastAction = { [weak self] in self?.updateSettings() }
            loadingMessage = "Saving settings..."
            
            do {
                // Apply settings directly
                try finderManager.setDefaultViewStyle(to: defaultViewStyle)
                try finderManager.setGlobalOption(.showPathBar, to: showPathBar)
                try finderManager.setGlobalOption(.showStatusBar, to: showStatusBar)
                try finderManager.setGlobalOption(.showSidebar, to: showSidebar)
                try finderManager.setGlobalOption(.showPreviewPane, to: showPreviewPane)
                // Note: showToolbar and showTabBar are not available in FinderManager
                
                showSuccess("Settings saved successfully")
            } catch {
                showError("Failed to save settings", error: error)
            }
        }
    }
    
    func relaunchFinder() {
        Task {
            isLoading = true
            errorMessage = nil
            lastAction = { [weak self] in self?.relaunchFinder() }
            loadingMessage = "Relaunching Finder..."
            
            do {
                // First apply current settings
                try finderManager.setDefaultViewStyle(to: defaultViewStyle)
                try finderManager.setGlobalOption(.showPathBar, to: showPathBar)
                try finderManager.setGlobalOption(.showStatusBar, to: showStatusBar)
                try finderManager.setGlobalOption(.showSidebar, to: showSidebar)
                try finderManager.setGlobalOption(.showPreviewPane, to: showPreviewPane)
                
                // Then relaunch Finder
                try finderManager.relaunchFinder()
                
                isLoading = false
                showSuccess("Finder relaunched successfully")
            } catch {
                isLoading = false
                showError("Failed to relaunch Finder", error: error)
            }
        }
    }
    
    func applyToAllExistingFolders() {
        Task {
            isLoading = true
            errorMessage = nil
            lastAction = { [weak self] in self?.applyToAllExistingFolders() }
            loadingMessage = "Applying settings to all folders..."
            
            do {
                // Apply settings and reset all folder views
                try finderManager.setDefaultViewStyle(to: defaultViewStyle)
                try finderManager.setGlobalOption(.showPathBar, to: showPathBar)
                try finderManager.setGlobalOption(.showStatusBar, to: showStatusBar)
                try finderManager.setGlobalOption(.showSidebar, to: showSidebar)
                try finderManager.setGlobalOption(.showPreviewPane, to: showPreviewPane)
                
                // Reset all existing folder views
                try finderManager.resetAllExistingViews()
                
                isLoading = false
                showSuccess("Settings applied to all folders")
            } catch {
                isLoading = false
                showError("Failed to apply settings to all folders", error: error)
            }
        }
    }
    
    func retryLastAction() {
        errorMessage = nil
        lastAction?()
    }
    
    // MARK: - Private Methods
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
        
        // Add more descriptive error messages based on the error type
        if error.localizedDescription.contains("permission") {
            detailedMessage += ". Please check Finder permissions in System Settings > Privacy & Security"
        } else if error.localizedDescription.contains("not found") {
            detailedMessage += ". The requested file or setting could not be found"
        } else {
            detailedMessage += ": \(error.localizedDescription)"
        }
        
        errorMessage = detailedMessage
    }
}