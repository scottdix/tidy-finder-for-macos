#!/bin/bash

# Script to generate TidyFinder Xcode project
# This script uses XcodeGen to create a proper Xcode project

set -e  # Exit on error

echo "🚀 TidyFinder Xcode Project Generator"
echo "====================================="

# Check if XcodeGen is installed
if ! command -v xcodegen &> /dev/null; then
    echo "📦 XcodeGen not found. Installing via Homebrew..."
    if ! command -v brew &> /dev/null; then
        echo "❌ Error: Homebrew is not installed. Please install Homebrew first."
        echo "Visit: https://brew.sh"
        exit 1
    fi
    brew install xcodegen
fi

# Define project directory
PROJECT_DIR="/Users/scottdix/Documents/tidyfinder/TidyFinder"

# Create project directory structure
echo "📁 Creating project directory structure..."
mkdir -p "$PROJECT_DIR"
mkdir -p "$PROJECT_DIR/Sources/TidyFinder"
mkdir -p "$PROJECT_DIR/Tests/TidyFinderTests"
mkdir -p "$PROJECT_DIR/Resources"

# Create project.yml for XcodeGen
echo "📝 Creating XcodeGen configuration..."
cat > "$PROJECT_DIR/project.yml" << 'EOF'
name: TidyFinder
options:
  bundleIdPrefix: com.scottdix
  deploymentTarget:
    macOS: "13.0"
  createIntermediateGroups: true
  groupSortPosition: top
settings:
  PRODUCT_BUNDLE_IDENTIFIER: com.scottdix.TidyFinder
  MARKETING_VERSION: 1.0.0
  CURRENT_PROJECT_VERSION: 1
  DEVELOPMENT_TEAM: ""
  CODE_SIGN_STYLE: Automatic
  SWIFT_VERSION: 5.9
  MACOSX_DEPLOYMENT_TARGET: 13.0
  ENABLE_HARDENED_RUNTIME: YES
  ENABLE_APP_SANDBOX: YES
targets:
  TidyFinder:
    type: application
    platform: macOS
    deploymentTarget: "13.0"
    sources:
      - Sources/TidyFinder
    resources:
      - Resources
    info:
      path: Resources/Info.plist
      properties:
        CFBundleDisplayName: TidyFinder
        CFBundleName: TidyFinder
        CFBundleShortVersionString: "1.0.0"
        CFBundleVersion: "1"
        LSMinimumSystemVersion: "13.0"
        NSHighResolutionCapable: true
        NSMainStoryboardFile: ""
        NSPrincipalClass: NSApplication
        LSApplicationCategoryType: public.app-category.utilities
    entitlements:
      path: Resources/TidyFinder.entitlements
      properties:
        com.apple.security.app-sandbox: true
        com.apple.security.files.user-selected.read-write: true
        com.apple.security.network.client: true
    settings:
      PRODUCT_BUNDLE_IDENTIFIER: com.scottdix.TidyFinder
      INFOPLIST_FILE: Resources/Info.plist
      CODE_SIGN_ENTITLEMENTS: Resources/TidyFinder.entitlements
      ASSETCATALOG_COMPILER_APPICON_NAME: AppIcon
      SWIFT_VERSION: 5.9
      MACOSX_DEPLOYMENT_TARGET: 13.0
  TidyFinderTests:
    type: bundle.unit-test
    platform: macOS
    deploymentTarget: "13.0"
    sources:
      - Tests/TidyFinderTests
    dependencies:
      - target: TidyFinder
        link: false
    settings:
      PRODUCT_BUNDLE_IDENTIFIER: com.scottdix.TidyFinderTests
      BUNDLE_LOADER: $(TEST_HOST)
      TEST_HOST: $(BUILT_PRODUCTS_DIR)/TidyFinder.app/Contents/MacOS/TidyFinder
      SWIFT_VERSION: 5.9
      MACOSX_DEPLOYMENT_TARGET: 13.0
EOF

# Create TidyFinderApp.swift
echo "📱 Creating SwiftUI app structure..."
cat > "$PROJECT_DIR/Sources/TidyFinder/TidyFinderApp.swift" << 'EOF'
//
//  TidyFinderApp.swift
//  TidyFinder
//
//  Created by generate_xcode_project.sh
//

import SwiftUI

@main
struct TidyFinderApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.automatic)
        .windowResizability(.contentSize)
    }
}
EOF

# Create ContentView.swift
cat > "$PROJECT_DIR/Sources/TidyFinder/ContentView.swift" << 'EOF'
//
//  ContentView.swift
//  TidyFinder
//
//  Created by generate_xcode_project.sh
//

import SwiftUI

struct ContentView: View {
    @State private var searchText = ""
    @State private var selectedPath: String?
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("TidyFinder")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Spacer()
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor))
            
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField("Search files and folders...", text: $searchText)
                    .textFieldStyle(.plain)
                    .font(.title3)
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor))
            
            // Results area
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    if searchText.isEmpty {
                        Text("Enter a search term to find files and folders")
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 50)
                    } else {
                        // Placeholder for search results
                        ForEach(0..<5, id: \.self) { index in
                            HStack {
                                Image(systemName: "folder")
                                    .foregroundColor(.blue)
                                
                                VStack(alignment: .leading) {
                                    Text("Example File \(index + 1).txt")
                                        .fontWeight(.medium)
                                    Text("/Users/example/Documents/")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color(NSColor.controlBackgroundColor))
                            .cornerRadius(8)
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            
            // Status bar
            HStack {
                Text(searchText.isEmpty ? "Ready" : "Searching...")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if !searchText.isEmpty {
                    Text("5 results")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color(NSColor.separatorColor).opacity(0.1))
        }
        .frame(width: 800, height: 600)
    }
}

#Preview {
    ContentView()
}
EOF

# Create Info.plist
echo "📋 Creating Info.plist..."
cat > "$PROJECT_DIR/Resources/Info.plist" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>$(DEVELOPMENT_LANGUAGE)</string>
    <key>CFBundleDisplayName</key>
    <string>TidyFinder</string>
    <key>CFBundleExecutable</key>
    <string>$(EXECUTABLE_NAME)</string>
    <key>CFBundleIdentifier</key>
    <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>$(PRODUCT_NAME)</string>
    <key>CFBundlePackageType</key>
    <string>$(PRODUCT_BUNDLE_PACKAGE_TYPE)</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSApplicationCategoryType</key>
    <string>public.app-category.utilities</string>
    <key>LSMinimumSystemVersion</key>
    <string>$(MACOSX_DEPLOYMENT_TARGET)</string>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>NSHumanReadableCopyright</key>
    <string>Copyright © 2025 Scott Dix. All rights reserved.</string>
</dict>
</plist>
EOF

# Create Entitlements file
echo "🔐 Creating entitlements file..."
cat > "$PROJECT_DIR/Resources/TidyFinder.entitlements" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.security.app-sandbox</key>
    <true/>
    <key>com.apple.security.files.user-selected.read-write</key>
    <true/>
    <key>com.apple.security.network.client</key>
    <true/>
</dict>
</plist>
EOF

# Create a simple test file
echo "🧪 Creating unit test..."
cat > "$PROJECT_DIR/Tests/TidyFinderTests/TidyFinderTests.swift" << 'EOF'
//
//  TidyFinderTests.swift
//  TidyFinderTests
//
//  Created by generate_xcode_project.sh
//

import XCTest
@testable import TidyFinder

final class TidyFinderTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(1 + 1, 2, "Basic math should work")
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            for _ in 0..<1000 {
                _ = String(describing: Date())
            }
        }
    }
}
EOF

# Create .gitignore
echo "📝 Creating .gitignore..."
cat > "$PROJECT_DIR/.gitignore" << 'EOF'
# Xcode
#
# gitignore contributors: remember to update Global/Xcode.gitignore, Objective-C.gitignore & Swift.gitignore

## User settings
xcuserdata/

## compatibility with Xcode 8 and earlier (ignoring not required starting Xcode 9)
*.xcscmblueprint
*.xccheckout

## compatibility with Xcode 3 and earlier (ignoring not required starting Xcode 4)
build/
DerivedData/
*.moved-aside
*.pbxuser
!default.pbxuser
*.mode1v3
!default.mode1v3
*.mode2v3
!default.mode2v3
*.perspectivev3
!default.perspectivev3

## Obj-C/Swift specific
*.hmap

## App packaging
*.ipa
*.dSYM.zip
*.dSYM

## Playgrounds
timeline.xctimeline
playground.xcworkspace

# Swift Package Manager
.build/

# CocoaPods
Pods/

# Carthage
Carthage/Build/

# fastlane
fastlane/report.xml
fastlane/Preview.html
fastlane/screenshots/**/*.png
fastlane/test_output

# Code Injection
iOSInjectionProject/

# macOS
.DS_Store

# XcodeGen
*.xcodeproj
*.xcworkspace
EOF

# Generate the Xcode project
echo "🔨 Generating Xcode project..."
cd "$PROJECT_DIR"
xcodegen generate

echo "✅ Success! TidyFinder Xcode project has been generated at:"
echo "   $PROJECT_DIR/TidyFinder.xcodeproj"
echo ""
echo "📌 Next steps:"
echo "   1. Open the project: open $PROJECT_DIR/TidyFinder.xcodeproj"
echo "   2. Select your development team in project settings"
echo "   3. Build and run the project (⌘+R)"
echo ""
echo "📦 Project details:"
echo "   - macOS app with SwiftUI interface"
echo "   - Bundle ID: com.scottdix.TidyFinder"
echo "   - Minimum macOS version: 13.0"
echo "   - Unit tests included"
echo "   - App Sandbox enabled with file access permissions"