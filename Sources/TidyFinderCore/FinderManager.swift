import Foundation

public class FinderManager {
    public enum ViewStyle: String, CaseIterable {
        case list = "Nlsv"
        case icon = "icnv"
        case column = "clmv"
        case gallery = "glyv"
        
        public var displayName: String {
            switch self {
            case .list: return "List"
            case .icon: return "Icon"
            case .column: return "Column"
            case .gallery: return "Gallery"
            }
        }
    }
    
    public enum FinderOption: String, CaseIterable {
        case showPathBar = "ShowPathbar"
        case showStatusBar = "ShowStatusBar"
        case showSidebar = "ShowSidebar"
        case showPreviewPane = "ShowPreviewPane"
        
        public var displayName: String {
            switch self {
            case .showPathBar: return "Show Path Bar"
            case .showStatusBar: return "Show Status Bar"
            case .showSidebar: return "Show Sidebar"
            case .showPreviewPane: return "Show Preview Pane"
            }
        }
    }
    
    public init() {}
    
    public func setDefaultViewStyle(to style: ViewStyle) throws {
        let command = "defaults write com.apple.finder FXPreferredViewStyle -string \"\(style.rawValue)\""
        try ShellRunner.execute(command: command)
        print("Default view style set to: \(style.displayName)")
    }
    
    public func setGlobalOption(_ option: FinderOption, to value: Bool) throws {
        let boolString = value ? "true" : "false"
        let command = "defaults write com.apple.finder \(option.rawValue) -bool \(boolString)"
        try ShellRunner.execute(command: command)
        print("\(option.displayName): \(value ? "Enabled" : "Disabled")")
    }
    
    public func resetAllExistingViews() throws {
        print("Removing all .DS_Store files to reset folder view preferences...")
        let command = "find ~ -name \".DS_Store\" -depth -exec rm {} \\;"
        try ShellRunner.execute(command: command)
        print("All folder view preferences have been reset.")
    }
    
    public func relaunchFinder() throws {
        print("Relaunching Finder...")
        let command = "killall Finder"
        try ShellRunner.execute(command: command)
        print("Finder relaunched successfully.")
    }
    
    public func getCurrentViewStyle() -> ViewStyle? {
        do {
            let output = try ShellRunner.execute(command: "defaults read com.apple.finder FXPreferredViewStyle")
            return ViewStyle.allCases.first { $0.rawValue == output }
        } catch {
            return nil
        }
    }
    
    public func getOptionValue(_ option: FinderOption) -> Bool {
        do {
            let output = try ShellRunner.execute(command: "defaults read com.apple.finder \(option.rawValue)")
            return output == "1" || output.lowercased() == "true"
        } catch {
            return false
        }
    }
}