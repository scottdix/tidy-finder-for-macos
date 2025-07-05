import Foundation
import TidyFinderCore

// MARK: - Profile Model
struct Profile: Codable, Identifiable {
    let id: UUID
    let name: String
    let createdDate: Date
    let viewStyle: FinderManager.ViewStyle
    let showPathBar: Bool
    let showStatusBar: Bool
    let showSidebar: Bool
    let showPreviewPane: Bool
    
    // Additional properties that exist in ContentViewModel
    let showToolbar: Bool
    let showTabBar: Bool
    
    init(id: UUID = UUID(),
         name: String,
         createdDate: Date = Date(),
         viewStyle: FinderManager.ViewStyle,
         showPathBar: Bool,
         showStatusBar: Bool,
         showSidebar: Bool,
         showPreviewPane: Bool,
         showToolbar: Bool = true,
         showTabBar: Bool = true) {
        self.id = id
        self.name = name
        self.createdDate = createdDate
        self.viewStyle = viewStyle
        self.showPathBar = showPathBar
        self.showStatusBar = showStatusBar
        self.showSidebar = showSidebar
        self.showPreviewPane = showPreviewPane
        self.showToolbar = showToolbar
        self.showTabBar = showTabBar
    }
}

// MARK: - ProfilesManager
@MainActor
class ProfilesManager: ObservableObject {
    @Published var profiles: [Profile] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let fileManager = FileManager.default
    private var profilesDirectory: URL? {
        guard let appSupport = fileManager.urls(for: .applicationSupportDirectory,
                                                in: .userDomainMask).first else {
            return nil
        }
        return appSupport.appendingPathComponent("TidyFinder")
    }
    
    private var profilesFile: URL? {
        profilesDirectory?.appendingPathComponent("profiles.json")
    }
    
    init() {
        createProfilesDirectoryIfNeeded()
        loadProfiles()
    }
    
    // MARK: - Public Methods
    
    func saveProfile(_ profile: Profile) {
        // Check if profile with same name exists
        if let existingIndex = profiles.firstIndex(where: { $0.name == profile.name && $0.id != profile.id }) {
            errorMessage = "A profile with the name '\(profile.name)' already exists"
            return
        }
        
        // Add or update profile
        if let index = profiles.firstIndex(where: { $0.id == profile.id }) {
            profiles[index] = profile
        } else {
            profiles.append(profile)
        }
        
        saveProfilesToFile()
    }
    
    func deleteProfile(_ profile: Profile) {
        profiles.removeAll { $0.id == profile.id }
        saveProfilesToFile()
    }
    
    func renameProfile(_ profile: Profile, newName: String) {
        guard !newName.isEmpty else {
            errorMessage = "Profile name cannot be empty"
            return
        }
        
        // Check if name already exists
        if profiles.contains(where: { $0.name == newName && $0.id != profile.id }) {
            errorMessage = "A profile with the name '\(newName)' already exists"
            return
        }
        
        if let index = profiles.firstIndex(where: { $0.id == profile.id }) {
            let updatedProfile = Profile(
                id: profile.id,
                name: newName,
                createdDate: profile.createdDate,
                viewStyle: profile.viewStyle,
                showPathBar: profile.showPathBar,
                showStatusBar: profile.showStatusBar,
                showSidebar: profile.showSidebar,
                showPreviewPane: profile.showPreviewPane,
                showToolbar: profile.showToolbar,
                showTabBar: profile.showTabBar
            )
            profiles[index] = updatedProfile
            saveProfilesToFile()
        }
    }
    
    func exportProfile(_ profile: Profile, to url: URL) {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(profile)
            try data.write(to: url)
        } catch {
            errorMessage = "Failed to export profile: \(error.localizedDescription)"
        }
    }
    
    func importProfile(from url: URL) {
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            var profile = try decoder.decode(Profile.self, from: data)
            
            // Generate new ID to avoid conflicts
            let newId = UUID()
            let newDate = Date()
            
            // Check for name conflicts
            var finalName = profile.name
            var counter = 1
            while profiles.contains(where: { $0.name == finalName }) {
                finalName = "\(profile.name) (\(counter))"
                counter += 1
            }
            
            let importedProfile = Profile(
                id: newId,
                name: finalName,
                createdDate: newDate,
                viewStyle: profile.viewStyle,
                showPathBar: profile.showPathBar,
                showStatusBar: profile.showStatusBar,
                showSidebar: profile.showSidebar,
                showPreviewPane: profile.showPreviewPane,
                showToolbar: profile.showToolbar,
                showTabBar: profile.showTabBar
            )
            
            profile = importedProfile
            
            saveProfile(profile)
        } catch {
            errorMessage = "Failed to import profile: \(error.localizedDescription)"
        }
    }
    
    // MARK: - Private Methods
    
    private func createProfilesDirectoryIfNeeded() {
        guard let directory = profilesDirectory else { return }
        
        if !fileManager.fileExists(atPath: directory.path) {
            do {
                try fileManager.createDirectory(at: directory,
                                              withIntermediateDirectories: true,
                                              attributes: nil)
            } catch {
                print("Failed to create profiles directory: \(error)")
            }
        }
    }
    
    private func loadProfiles() {
        guard let file = profilesFile,
              fileManager.fileExists(atPath: file.path) else {
            return
        }
        
        do {
            let data = try Data(contentsOf: file)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            profiles = try decoder.decode([Profile].self, from: data)
        } catch {
            print("Failed to load profiles: \(error)")
        }
    }
    
    private func saveProfilesToFile() {
        guard let file = profilesFile else { return }
        
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(profiles)
            try data.write(to: file)
        } catch {
            errorMessage = "Failed to save profiles: \(error.localizedDescription)"
        }
    }
}

// MARK: - Codable Extensions for FinderManager.ViewStyle
extension FinderManager.ViewStyle: Codable {
    enum CodingKeys: String, CodingKey {
        case rawValue
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rawValue = try container.decode(String.self, forKey: .rawValue)
        guard let style = FinderManager.ViewStyle(rawValue: rawValue) else {
            throw DecodingError.dataCorruptedError(forKey: .rawValue,
                                                  in: container,
                                                  debugDescription: "Invalid view style raw value: \(rawValue)")
        }
        self = style
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(rawValue, forKey: .rawValue)
    }
}