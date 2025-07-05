import Foundation
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
    
    // MARK: - Private Properties
    private let finderManager = FinderManager()
    
    // MARK: - Initialization
    init() {
        loadCurrentSettings()
    }
    
    // MARK: - Public Methods
    func loadCurrentSettings() {
        Task {
            isLoading = true
            errorMessage = nil
            
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
            isLoading = true
            errorMessage = nil
            
            do {
                // Apply settings directly
                try finderManager.setDefaultViewStyle(to: defaultViewStyle)
                try finderManager.setGlobalOption(.showPathBar, to: showPathBar)
                try finderManager.setGlobalOption(.showStatusBar, to: showStatusBar)
                try finderManager.setGlobalOption(.showSidebar, to: showSidebar)
                try finderManager.setGlobalOption(.showPreviewPane, to: showPreviewPane)
                // Note: showToolbar and showTabBar are not available in FinderManager
                
                isLoading = false
            } catch {
                errorMessage = "Failed to update settings: \(error.localizedDescription)"
                isLoading = false
            }
        }
    }
    
    func relaunchFinder() {
        Task {
            isLoading = true
            errorMessage = nil
            
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
            } catch {
                errorMessage = "Failed to relaunch Finder: \(error.localizedDescription)"
                isLoading = false
            }
        }
    }
    
    func applyToAllExistingFolders() {
        Task {
            isLoading = true
            errorMessage = nil
            
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
            } catch {
                errorMessage = "Failed to apply settings to all folders: \(error.localizedDescription)"
                isLoading = false
            }
        }
    }
}