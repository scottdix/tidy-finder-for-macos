# TidyFinder Xcode Project Generation

This repository contains two scripts for generating the TidyFinder Xcode project programmatically:

## Scripts

### 1. `generate_xcode_project.sh` (Recommended)
Uses **XcodeGen**, a popular tool that generates Xcode projects from a simple YAML specification.

**Advantages:**
- Clean, maintainable project configuration via YAML
- Automatically handles complex project relationships
- Easy to update and regenerate
- Widely used in the iOS/macOS development community
- Generates proper UUIDs and references

**Requirements:**
- Homebrew (for installing XcodeGen)
- macOS with Xcode installed

**Usage:**
```bash
./generate_xcode_project.sh
```

The script will:
1. Check if XcodeGen is installed (installs it via Homebrew if not)
2. Create the project directory structure
3. Generate source files (TidyFinderApp.swift, ContentView.swift, tests)
4. Create Info.plist and entitlements
5. Generate the Xcode project using XcodeGen

### 2. `generate_xcode_project_manual.sh` (Alternative)
Manually creates the entire Xcode project structure without external dependencies.

**Advantages:**
- No external dependencies required
- Complete control over project structure
- Educational - shows how Xcode projects are structured internally

**Disadvantages:**
- More complex and harder to maintain
- Manual UUID generation
- May require updates for new Xcode versions

**Usage:**
```bash
./generate_xcode_project_manual.sh
```

## Project Details

Both scripts generate a TidyFinder project with:
- **Platform:** macOS
- **UI Framework:** SwiftUI
- **Language:** Swift 5.9
- **Bundle ID:** com.scottdix.TidyFinder
- **Minimum macOS Version:** 13.0
- **Features:**
  - Basic SwiftUI app structure
  - Unit tests
  - App Sandbox with file access permissions
  - Modern macOS app configuration

## Generated Project Structure

```
TidyFinder/
├── TidyFinder.xcodeproj/
├── Sources/
│   └── TidyFinder/
│       ├── TidyFinderApp.swift
│       └── ContentView.swift
├── Tests/
│   └── TidyFinderTests/
│       └── TidyFinderTests.swift
├── Resources/
│   ├── Info.plist
│   └── TidyFinder.entitlements
└── .gitignore
```

## After Generation

1. Open the project:
   ```bash
   open /Users/scottdix/Documents/tidyfinder/TidyFinder/TidyFinder.xcodeproj
   ```

2. In Xcode:
   - Select your development team in the project settings
   - Build and run the project (⌘+R)

## Customization

### Using XcodeGen (Recommended)
Edit the `project.yml` file in the generated project directory to customize:
- Target settings
- Build configurations
- Dependencies
- File organization

Then regenerate the project:
```bash
cd /Users/scottdix/Documents/tidyfinder/TidyFinder
xcodegen generate
```

### Manual Method
Edit the script directly to modify:
- Project settings in `project.pbxproj`
- Source file templates
- Build configurations

## Troubleshooting

### XcodeGen Not Found
If the first script fails to find XcodeGen:
1. Ensure Homebrew is installed: https://brew.sh
2. Install XcodeGen manually: `brew install xcodegen`

### Project Won't Open
- Ensure you have Xcode installed
- Check that the project was generated in the correct location
- Try the manual generation script as an alternative

### Code Signing Issues
- Open the project in Xcode
- Select your development team in the project settings
- Ensure you have a valid Apple Developer account (free tier is sufficient)

## License

These scripts are provided as-is for generating the TidyFinder project structure.