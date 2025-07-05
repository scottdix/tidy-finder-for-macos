import SwiftUI
import TidyFinderCore
import UniformTypeIdentifiers

struct ProfilesView: View {
    @StateObject private var profilesManager = ProfilesManager()
    @ObservedObject var contentViewModel: ContentViewModel
    @State private var showingCreateProfile = false
    @State private var showingDeleteAlert = false
    @State private var profileToDelete: Profile?
    @State private var showingRenameAlert = false
    @State private var profileToRename: Profile?
    @State private var newProfileName = ""
    @State private var showingImportPicker = false
    @State private var showingExportPicker = false
    @State private var profileToExport: Profile?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header Section
                ProfilesHeaderView(
                    profilesManager: profilesManager,
                    contentViewModel: contentViewModel,
                    showingCreateProfile: $showingCreateProfile,
                    showingImportPicker: $showingImportPicker
                )
                
                // Profiles List
                ProfilesListView(
                    profiles: profilesManager.profiles,
                    contentViewModel: contentViewModel,
                    onLoadProfile: loadProfile,
                    onDeleteProfile: { profile in
                        profileToDelete = profile
                        showingDeleteAlert = true
                    },
                    onRenameProfile: { profile in
                        profileToRename = profile
                        newProfileName = profile.name
                        showingRenameAlert = true
                    },
                    onExportProfile: { profile in
                        profileToExport = profile
                        showingExportPicker = true
                    }
                )
            }
            .padding(20)
        }
        .navigationTitle("Profiles")
        .sheet(isPresented: $showingCreateProfile) {
            CreateProfileView(
                profilesManager: profilesManager,
                contentViewModel: contentViewModel
            )
        }
        .fileImporter(
            isPresented: $showingImportPicker,
            allowedContentTypes: [.json],
            allowsMultipleSelection: false
        ) { result in
            handleImport(result: result)
        }
        .fileExporter(
            isPresented: $showingExportPicker,
            document: profileToExport.flatMap { ProfileDocument(profile: $0) },
            contentType: .json,
            defaultFilename: profileToExport?.name ?? "Profile"
        ) { result in
            handleExport(result: result)
        }
        .alert("Delete Profile", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let profile = profileToDelete {
                    profilesManager.deleteProfile(profile)
                }
            }
        } message: {
            Text("Are you sure you want to delete the profile '\(profileToDelete?.name ?? "")'? This action cannot be undone.")
        }
        .alert("Rename Profile", isPresented: $showingRenameAlert) {
            TextField("Profile Name", text: $newProfileName)
            Button("Cancel", role: .cancel) { }
            Button("Rename") {
                if let profile = profileToRename {
                    profilesManager.renameProfile(profile, newName: newProfileName)
                }
            }
        } message: {
            Text("Enter a new name for the profile.")
        }
        .alert("Error", isPresented: .constant(profilesManager.errorMessage != nil)) {
            Button("OK") {
                profilesManager.errorMessage = nil
            }
        } message: {
            Text(profilesManager.errorMessage ?? "")
        }
    }
    
    private func loadProfile(_ profile: Profile) {
        contentViewModel.loadProfile(profile)
    }
    
    private func handleImport(result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            if let url = urls.first {
                profilesManager.importProfile(from: url)
            }
        case .failure(let error):
            profilesManager.errorMessage = "Failed to import profile: \(error.localizedDescription)"
        }
    }
    
    private func handleExport(result: Result<URL, Error>) {
        switch result {
        case .success(let url):
            if let profile = profileToExport {
                profilesManager.exportProfile(profile, to: url)
            }
        case .failure(let error):
            profilesManager.errorMessage = "Failed to export profile: \(error.localizedDescription)"
        }
    }
}

// MARK: - Profiles Header View
struct ProfilesHeaderView: View {
    @ObservedObject var profilesManager: ProfilesManager
    @ObservedObject var contentViewModel: ContentViewModel
    @Binding var showingCreateProfile: Bool
    @Binding var showingImportPicker: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "person.2.badge.gearshape")
                    .foregroundColor(.accentColor)
                Text("Finder Profiles")
                    .font(.headline)
            }
            
            Text("Save and load different Finder configurations")
                .font(.caption)
                .foregroundColor(.secondary)
            
            HStack(spacing: 12) {
                Button(action: {
                    showingCreateProfile = true
                }) {
                    Label("Create Profile", systemImage: "plus")
                }
                .controlSize(.regular)
                .buttonStyle(.borderedProminent)
                
                Button(action: {
                    showingImportPicker = true
                }) {
                    Label("Import", systemImage: "square.and.arrow.down")
                }
                .controlSize(.regular)
                .buttonStyle(.bordered)
                
                Spacer()
                
                Text("\(profilesManager.profiles.count) profile\(profilesManager.profiles.count == 1 ? "" : "s")")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(16)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
    }
}

// MARK: - Profiles List View
struct ProfilesListView: View {
    let profiles: [Profile]
    @ObservedObject var contentViewModel: ContentViewModel
    let onLoadProfile: (Profile) -> Void
    let onDeleteProfile: (Profile) -> Void
    let onRenameProfile: (Profile) -> Void
    let onExportProfile: (Profile) -> Void
    
    var body: some View {
        if profiles.isEmpty {
            EmptyProfilesView()
        } else {
            LazyVGrid(columns: [
                GridItem(.adaptive(minimum: 300), spacing: 16)
            ], spacing: 16) {
                ForEach(profiles) { profile in
                    ProfileCardView(
                        profile: profile,
                        contentViewModel: contentViewModel,
                        onLoadProfile: onLoadProfile,
                        onDeleteProfile: onDeleteProfile,
                        onRenameProfile: onRenameProfile,
                        onExportProfile: onExportProfile
                    )
                }
            }
        }
    }
}

// MARK: - Profile Card View
struct ProfileCardView: View {
    let profile: Profile
    @ObservedObject var contentViewModel: ContentViewModel
    let onLoadProfile: (Profile) -> Void
    let onDeleteProfile: (Profile) -> Void
    let onRenameProfile: (Profile) -> Void
    let onExportProfile: (Profile) -> Void
    
    @State private var isHovered = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Profile Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(profile.name)
                        .font(.headline)
                        .lineLimit(1)
                    
                    Text(profile.createdDate, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Quick actions menu
                Menu {
                    Button(action: { onLoadProfile(profile) }) {
                        Label("Load Profile", systemImage: "arrow.down.circle")
                    }
                    
                    Button(action: { onRenameProfile(profile) }) {
                        Label("Rename", systemImage: "pencil")
                    }
                    
                    Button(action: { onExportProfile(profile) }) {
                        Label("Export", systemImage: "square.and.arrow.up")
                    }
                    
                    Divider()
                    
                    Button(action: { onDeleteProfile(profile) }) {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            // Profile Settings Preview
            ProfileSettingsPreview(profile: profile)
            
            // Action Buttons
            HStack(spacing: 8) {
                Button(action: { onLoadProfile(profile) }) {
                    Label("Load", systemImage: "arrow.down.circle")
                        .font(.caption)
                }
                .controlSize(.small)
                .buttonStyle(.borderedProminent)
                
                Button(action: { onExportProfile(profile) }) {
                    Label("Export", systemImage: "square.and.arrow.up")
                        .font(.caption)
                }
                .controlSize(.small)
                .buttonStyle(.bordered)
                
                Spacer()
                
                if isCurrentProfile(profile) {
                    Label("Current", systemImage: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
        }
        .padding(16)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isCurrentProfile(profile) ? Color.accentColor : Color.clear, lineWidth: 2)
        )
        .scaleEffect(isHovered ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isHovered)
        .onHover { hovering in
            isHovered = hovering
        }
    }
    
    private func isCurrentProfile(_ profile: Profile) -> Bool {
        return profile.viewStyle == contentViewModel.defaultViewStyle &&
               profile.showPathBar == contentViewModel.showPathBar &&
               profile.showStatusBar == contentViewModel.showStatusBar &&
               profile.showSidebar == contentViewModel.showSidebar &&
               profile.showPreviewPane == contentViewModel.showPreviewPane &&
               profile.showToolbar == contentViewModel.showToolbar &&
               profile.showTabBar == contentViewModel.showTabBar
    }
}

// MARK: - Profile Settings Preview
struct ProfileSettingsPreview: View {
    let profile: Profile
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("View Style:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Label(profile.viewStyle.displayName, systemImage: viewStyleIcon(profile.viewStyle))
                    .font(.caption)
                    .foregroundColor(.primary)
            }
            
            let enabledOptions = getEnabledOptions(profile)
            if !enabledOptions.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Enabled Options:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    ForEach(enabledOptions, id: \.self) { option in
                        HStack {
                            Image(systemName: "checkmark")
                                .font(.caption2)
                                .foregroundColor(.green)
                            
                            Text(option)
                                .font(.caption2)
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
        }
        .padding(12)
        .background(Color(NSColor.controlBackgroundColor).opacity(0.5))
        .cornerRadius(6)
    }
    
    private func viewStyleIcon(_ style: FinderManager.ViewStyle) -> String {
        switch style {
        case .icon: return "square.grid.2x2"
        case .list: return "list.bullet"
        case .column: return "rectangle.split.3x1"
        case .gallery: return "square.grid.3x3"
        }
    }
    
    private func getEnabledOptions(_ profile: Profile) -> [String] {
        var options: [String] = []
        
        if profile.showPathBar { options.append("Path Bar") }
        if profile.showStatusBar { options.append("Status Bar") }
        if profile.showSidebar { options.append("Sidebar") }
        if profile.showPreviewPane { options.append("Preview Pane") }
        if profile.showToolbar { options.append("Toolbar") }
        if profile.showTabBar { options.append("Tab Bar") }
        
        return options
    }
}

// MARK: - Empty Profiles View
struct EmptyProfilesView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.2.badge.gearshape")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            
            Text("No Profiles Yet")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("Create your first profile to save your current Finder configuration")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(40)
        .frame(maxWidth: .infinity)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
    }
}

// MARK: - Create Profile View
struct CreateProfileView: View {
    @ObservedObject var profilesManager: ProfilesManager
    @ObservedObject var contentViewModel: ContentViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var profileName = ""
    @State private var showingNameError = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 8) {
                    Image(systemName: "person.badge.plus")
                        .font(.system(size: 32))
                        .foregroundColor(.accentColor)
                    
                    Text("Create New Profile")
                        .font(.headline)
                    
                    Text("Save your current Finder configuration as a profile")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 20)
                
                // Profile Name Input
                VStack(alignment: .leading, spacing: 8) {
                    Text("Profile Name")
                        .font(.headline)
                    
                    TextField("Enter profile name", text: $profileName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onSubmit {
                            createProfile()
                        }
                    
                    if showingNameError {
                        Text("Please enter a profile name")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                
                // Current Settings Preview
                VStack(alignment: .leading, spacing: 12) {
                    Text("Current Settings")
                        .font(.headline)
                    
                    CurrentSettingsPreview(contentViewModel: contentViewModel)
                }
                
                Spacer()
                
                // Action Buttons
                HStack(spacing: 12) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .keyboardShortcut(.cancelAction)
                    
                    Button("Create Profile") {
                        createProfile()
                    }
                    .keyboardShortcut(.defaultAction)
                    .disabled(profileName.isEmpty)
                }
                .padding(.bottom, 20)
            }
            .padding(.horizontal, 20)
            .frame(width: 400, height: 500)
        }
    }
    
    private func createProfile() {
        guard !profileName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showingNameError = true
            return
        }
        
        showingNameError = false
        
        let profile = Profile(
            name: profileName.trimmingCharacters(in: .whitespacesAndNewlines),
            viewStyle: contentViewModel.defaultViewStyle,
            showPathBar: contentViewModel.showPathBar,
            showStatusBar: contentViewModel.showStatusBar,
            showSidebar: contentViewModel.showSidebar,
            showPreviewPane: contentViewModel.showPreviewPane,
            showToolbar: contentViewModel.showToolbar,
            showTabBar: contentViewModel.showTabBar
        )
        
        profilesManager.saveProfile(profile)
        dismiss()
    }
}

// MARK: - Current Settings Preview
struct CurrentSettingsPreview: View {
    @ObservedObject var contentViewModel: ContentViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("View Style:")
                    .font(.subheadline)
                Spacer()
                Text(contentViewModel.defaultViewStyle.displayName)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Divider()
            
            SettingRow(title: "Path Bar", isEnabled: contentViewModel.showPathBar)
            SettingRow(title: "Status Bar", isEnabled: contentViewModel.showStatusBar)
            SettingRow(title: "Sidebar", isEnabled: contentViewModel.showSidebar)
            SettingRow(title: "Preview Pane", isEnabled: contentViewModel.showPreviewPane)
            SettingRow(title: "Toolbar", isEnabled: contentViewModel.showToolbar)
            SettingRow(title: "Tab Bar", isEnabled: contentViewModel.showTabBar)
        }
        .padding(16)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
    }
}

struct SettingRow: View {
    let title: String
    let isEnabled: Bool
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
            Spacer()
            Image(systemName: isEnabled ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isEnabled ? .green : .secondary)
        }
    }
}

// MARK: - Profile Document for Export
struct ProfileDocument: FileDocument {
    static var readableContentTypes = [UTType.json]
    static var writableContentTypes = [UTType.json]
    
    let profile: Profile
    
    init(profile: Profile) {
        self.profile = profile
    }
    
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        profile = try decoder.decode(Profile.self, from: data)
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(profile)
        return FileWrapper(regularFileWithContents: data)
    }
}

#Preview {
    ProfilesView(contentViewModel: ContentViewModel())
}