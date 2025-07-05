import Foundation

print("TidyFinder - Finder Preferences Manager")
print("Version 0.1.0")
print("========================================\n")

let manager = FinderManager()

func showCurrentSettings() {
    print("Current Finder Settings:")
    print("------------------------")
    
    if let currentStyle = manager.getCurrentViewStyle() {
        print("Default View Style: \(currentStyle.displayName)")
    } else {
        print("Default View Style: Unknown")
    }
    
    for option in FinderManager.FinderOption.allCases {
        let isEnabled = manager.getOptionValue(option)
        print("\(option.displayName): \(isEnabled ? "✓" : "✗")")
    }
    print("")
}

func demonstrateFeatures() {
    print("Available Features:")
    print("------------------")
    print("1. Set default view style (List, Icon, Column, Gallery)")
    print("2. Toggle Path Bar visibility")
    print("3. Toggle Status Bar visibility")
    print("4. Toggle Sidebar visibility")
    print("5. Toggle Preview Pane visibility")
    print("6. Reset all folder view preferences")
    print("7. Relaunch Finder\n")
    
    print("Example Commands (when interactive mode is implemented):")
    print("--------------------------------------------------------")
    print("• Set view to List: tidyfinder view list")
    print("• Enable Path Bar: tidyfinder option pathbar on")
    print("• Reset all views: tidyfinder reset")
    print("• Relaunch Finder: tidyfinder relaunch\n")
}

showCurrentSettings()
demonstrateFeatures()

print("Note: This is Sprint 1 - Core Logic Implementation")
print("The command-line interface will be enhanced in future sprints.")