#!/bin/bash

# Manual Xcode Project Generator for TidyFinder
# This script creates an Xcode project structure manually without external dependencies

set -e  # Exit on error

echo "🚀 TidyFinder Manual Xcode Project Generator"
echo "==========================================="

# Define project directory
PROJECT_DIR="/Users/scottdix/Documents/tidyfinder/TidyFinder"
PROJECT_NAME="TidyFinder"
BUNDLE_ID="com.scottdix.TidyFinder"

# Create project directory structure
echo "📁 Creating project directory structure..."
mkdir -p "$PROJECT_DIR"
mkdir -p "$PROJECT_DIR/$PROJECT_NAME.xcodeproj"
mkdir -p "$PROJECT_DIR/$PROJECT_NAME.xcodeproj/project.xcworkspace"
mkdir -p "$PROJECT_DIR/$PROJECT_NAME.xcodeproj/project.xcworkspace/xcshareddata"
mkdir -p "$PROJECT_DIR/$PROJECT_NAME.xcodeproj/xcshareddata/xcschemes"
mkdir -p "$PROJECT_DIR/Sources/TidyFinder"
mkdir -p "$PROJECT_DIR/Tests/TidyFinderTests"
mkdir -p "$PROJECT_DIR/Resources"

# Generate UUIDs for the project
generate_uuid() {
    uuidgen | tr -d '-' | tr '[:lower:]' '[:upper:]' | cut -c1-24
}

# Project UUIDs
PROJECT_UUID=$(generate_uuid)
MAIN_GROUP_UUID=$(generate_uuid)
PRODUCTS_GROUP_UUID=$(generate_uuid)
SOURCES_GROUP_UUID=$(generate_uuid)
TESTS_GROUP_UUID=$(generate_uuid)
RESOURCES_GROUP_UUID=$(generate_uuid)
APP_TARGET_UUID=$(generate_uuid)
TEST_TARGET_UUID=$(generate_uuid)
APP_PRODUCT_UUID=$(generate_uuid)
TEST_PRODUCT_UUID=$(generate_uuid)
BUILD_CONFIG_DEBUG_UUID=$(generate_uuid)
BUILD_CONFIG_RELEASE_UUID=$(generate_uuid)
BUILD_CONFIG_LIST_PROJECT_UUID=$(generate_uuid)
BUILD_CONFIG_LIST_APP_UUID=$(generate_uuid)
BUILD_CONFIG_LIST_TEST_UUID=$(generate_uuid)
APP_FILE_UUID=$(generate_uuid)
CONTENTVIEW_FILE_UUID=$(generate_uuid)
TESTFILE_UUID=$(generate_uuid)
INFO_PLIST_UUID=$(generate_uuid)
ENTITLEMENTS_UUID=$(generate_uuid)
APP_BUILD_FILE_UUID=$(generate_uuid)
CONTENTVIEW_BUILD_FILE_UUID=$(generate_uuid)
TEST_BUILD_FILE_UUID=$(generate_uuid)
RESOURCES_BUILD_PHASE_UUID=$(generate_uuid)
SOURCES_BUILD_PHASE_UUID=$(generate_uuid)
TEST_SOURCES_BUILD_PHASE_UUID=$(generate_uuid)
FRAMEWORKS_BUILD_PHASE_UUID=$(generate_uuid)
TEST_FRAMEWORKS_BUILD_PHASE_UUID=$(generate_uuid)
APP_NATIVE_TARGET_UUID=$(generate_uuid)
TEST_NATIVE_TARGET_UUID=$(generate_uuid)
TARGET_DEPENDENCY_UUID=$(generate_uuid)
CONTAINER_ITEM_PROXY_UUID=$(generate_uuid)

# Create TidyFinderApp.swift
echo "📱 Creating SwiftUI app structure..."
cat > "$PROJECT_DIR/Sources/TidyFinder/TidyFinderApp.swift" << 'EOF'
//
//  TidyFinderApp.swift
//  TidyFinder
//
//  Created by generate_xcode_project_manual.sh
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
//  Created by generate_xcode_project_manual.sh
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
//  Created by generate_xcode_project_manual.sh
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

# Create project.pbxproj
echo "📝 Creating project.pbxproj..."
cat > "$PROJECT_DIR/$PROJECT_NAME.xcodeproj/project.pbxproj" << EOF
// !$*UTF8*$!
{
	archiveVersion = 1;
	classes = {
	};
	objectVersion = 56;
	objects = {

/* Begin PBXBuildFile section */
		$APP_BUILD_FILE_UUID /* TidyFinderApp.swift in Sources */ = {isa = PBXBuildFile; fileRef = $APP_FILE_UUID /* TidyFinderApp.swift */; };
		$CONTENTVIEW_BUILD_FILE_UUID /* ContentView.swift in Sources */ = {isa = PBXBuildFile; fileRef = $CONTENTVIEW_FILE_UUID /* ContentView.swift */; };
		$TEST_BUILD_FILE_UUID /* TidyFinderTests.swift in Sources */ = {isa = PBXBuildFile; fileRef = $TESTFILE_UUID /* TidyFinderTests.swift */; };
/* End PBXBuildFile section */

/* Begin PBXContainerItemProxy section */
		$CONTAINER_ITEM_PROXY_UUID /* PBXContainerItemProxy */ = {
			isa = PBXContainerItemProxy;
			containerPortal = $PROJECT_UUID /* Project object */;
			proxyType = 1;
			remoteGlobalIDString = $APP_TARGET_UUID;
			remoteInfo = TidyFinder;
		};
/* End PBXContainerItemProxy section */

/* Begin PBXFileReference section */
		$APP_PRODUCT_UUID /* TidyFinder.app */ = {isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = TidyFinder.app; sourceTree = BUILT_PRODUCTS_DIR; };
		$APP_FILE_UUID /* TidyFinderApp.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = TidyFinderApp.swift; sourceTree = "<group>"; };
		$CONTENTVIEW_FILE_UUID /* ContentView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = ContentView.swift; sourceTree = "<group>"; };
		$INFO_PLIST_UUID /* Info.plist */ = {isa = PBXFileReference; lastKnownFileType = text.plist.xml; path = Info.plist; sourceTree = "<group>"; };
		$ENTITLEMENTS_UUID /* TidyFinder.entitlements */ = {isa = PBXFileReference; lastKnownFileType = text.plist.entitlements; path = TidyFinder.entitlements; sourceTree = "<group>"; };
		$TEST_PRODUCT_UUID /* TidyFinderTests.xctest */ = {isa = PBXFileReference; explicitFileType = wrapper.cfbundle; includeInIndex = 0; path = TidyFinderTests.xctest; sourceTree = BUILT_PRODUCTS_DIR; };
		$TESTFILE_UUID /* TidyFinderTests.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = TidyFinderTests.swift; sourceTree = "<group>"; };
/* End PBXFileReference section */

/* Begin PBXFrameworksBuildPhase section */
		$FRAMEWORKS_BUILD_PHASE_UUID /* Frameworks */ = {
			isa = PBXFrameworksBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
		$TEST_FRAMEWORKS_BUILD_PHASE_UUID /* Frameworks */ = {
			isa = PBXFrameworksBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXFrameworksBuildPhase section */

/* Begin PBXGroup section */
		$MAIN_GROUP_UUID = {
			isa = PBXGroup;
			children = (
				$SOURCES_GROUP_UUID /* Sources */,
				$TESTS_GROUP_UUID /* Tests */,
				$RESOURCES_GROUP_UUID /* Resources */,
				$PRODUCTS_GROUP_UUID /* Products */,
			);
			sourceTree = "<group>";
		};
		$PRODUCTS_GROUP_UUID /* Products */ = {
			isa = PBXGroup;
			children = (
				$APP_PRODUCT_UUID /* TidyFinder.app */,
				$TEST_PRODUCT_UUID /* TidyFinderTests.xctest */,
			);
			name = Products;
			sourceTree = "<group>";
		};
		$SOURCES_GROUP_UUID /* Sources */ = {
			isa = PBXGroup;
			children = (
				$APP_FILE_UUID /* TidyFinderApp.swift */,
				$CONTENTVIEW_FILE_UUID /* ContentView.swift */,
			);
			path = Sources/TidyFinder;
			sourceTree = "<group>";
		};
		$TESTS_GROUP_UUID /* Tests */ = {
			isa = PBXGroup;
			children = (
				$TESTFILE_UUID /* TidyFinderTests.swift */,
			);
			path = Tests/TidyFinderTests;
			sourceTree = "<group>";
		};
		$RESOURCES_GROUP_UUID /* Resources */ = {
			isa = PBXGroup;
			children = (
				$INFO_PLIST_UUID /* Info.plist */,
				$ENTITLEMENTS_UUID /* TidyFinder.entitlements */,
			);
			path = Resources;
			sourceTree = "<group>";
		};
/* End PBXGroup section */

/* Begin PBXNativeTarget section */
		$APP_NATIVE_TARGET_UUID /* TidyFinder */ = {
			isa = PBXNativeTarget;
			buildConfigurationList = $BUILD_CONFIG_LIST_APP_UUID /* Build configuration list for PBXNativeTarget "TidyFinder" */;
			buildPhases = (
				$SOURCES_BUILD_PHASE_UUID /* Sources */,
				$FRAMEWORKS_BUILD_PHASE_UUID /* Frameworks */,
				$RESOURCES_BUILD_PHASE_UUID /* Resources */,
			);
			buildRules = (
			);
			dependencies = (
			);
			name = TidyFinder;
			productName = TidyFinder;
			productReference = $APP_PRODUCT_UUID /* TidyFinder.app */;
			productType = "com.apple.product-type.application";
		};
		$TEST_NATIVE_TARGET_UUID /* TidyFinderTests */ = {
			isa = PBXNativeTarget;
			buildConfigurationList = $BUILD_CONFIG_LIST_TEST_UUID /* Build configuration list for PBXNativeTarget "TidyFinderTests" */;
			buildPhases = (
				$TEST_SOURCES_BUILD_PHASE_UUID /* Sources */,
				$TEST_FRAMEWORKS_BUILD_PHASE_UUID /* Frameworks */,
			);
			buildRules = (
			);
			dependencies = (
				$TARGET_DEPENDENCY_UUID /* PBXTargetDependency */,
			);
			name = TidyFinderTests;
			productName = TidyFinderTests;
			productReference = $TEST_PRODUCT_UUID /* TidyFinderTests.xctest */;
			productType = "com.apple.product-type.bundle.unit-test";
		};
/* End PBXNativeTarget section */

/* Begin PBXProject section */
		$PROJECT_UUID /* Project object */ = {
			isa = PBXProject;
			attributes = {
				BuildIndependentTargetsInParallel = 1;
				LastSwiftUpdateCheck = 1500;
				LastUpgradeCheck = 1500;
				TargetAttributes = {
					$APP_NATIVE_TARGET_UUID = {
						CreatedOnToolsVersion = 15.0;
					};
					$TEST_NATIVE_TARGET_UUID = {
						CreatedOnToolsVersion = 15.0;
						TestTargetID = $APP_NATIVE_TARGET_UUID;
					};
				};
			};
			buildConfigurationList = $BUILD_CONFIG_LIST_PROJECT_UUID /* Build configuration list for PBXProject "TidyFinder" */;
			compatibilityVersion = "Xcode 14.0";
			developmentRegion = en;
			hasScannedForEncodings = 0;
			knownRegions = (
				en,
				Base,
			);
			mainGroup = $MAIN_GROUP_UUID;
			productRefGroup = $PRODUCTS_GROUP_UUID /* Products */;
			projectDirPath = "";
			projectRoot = "";
			targets = (
				$APP_NATIVE_TARGET_UUID /* TidyFinder */,
				$TEST_NATIVE_TARGET_UUID /* TidyFinderTests */,
			);
		};
/* End PBXProject section */

/* Begin PBXResourcesBuildPhase section */
		$RESOURCES_BUILD_PHASE_UUID /* Resources */ = {
			isa = PBXResourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXResourcesBuildPhase section */

/* Begin PBXSourcesBuildPhase section */
		$SOURCES_BUILD_PHASE_UUID /* Sources */ = {
			isa = PBXSourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
				$CONTENTVIEW_BUILD_FILE_UUID /* ContentView.swift in Sources */,
				$APP_BUILD_FILE_UUID /* TidyFinderApp.swift in Sources */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
		$TEST_SOURCES_BUILD_PHASE_UUID /* Sources */ = {
			isa = PBXSourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
				$TEST_BUILD_FILE_UUID /* TidyFinderTests.swift in Sources */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXSourcesBuildPhase section */

/* Begin PBXTargetDependency section */
		$TARGET_DEPENDENCY_UUID /* PBXTargetDependency */ = {
			isa = PBXTargetDependency;
			target = $APP_NATIVE_TARGET_UUID /* TidyFinder */;
			targetProxy = $CONTAINER_ITEM_PROXY_UUID /* PBXContainerItemProxy */;
		};
/* End PBXTargetDependency section */

/* Begin XCBuildConfiguration section */
		$BUILD_CONFIG_DEBUG_UUID /* Debug */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ALWAYS_SEARCH_USER_PATHS = NO;
				ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS = YES;
				CLANG_ANALYZER_NONNULL = YES;
				CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE;
				CLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				CLANG_ENABLE_OBJC_WEAK = YES;
				CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES;
				CLANG_WARN_BOOL_CONVERSION = YES;
				CLANG_WARN_COMMA = YES;
				CLANG_WARN_CONSTANT_CONVERSION = YES;
				CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES;
				CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR;
				CLANG_WARN_DOCUMENTATION_COMMENTS = YES;
				CLANG_WARN_EMPTY_BODY = YES;
				CLANG_WARN_ENUM_CONVERSION = YES;
				CLANG_WARN_INFINITE_RECURSION = YES;
				CLANG_WARN_INT_CONVERSION = YES;
				CLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES;
				CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES;
				CLANG_WARN_OBJC_LITERAL_CONVERSION = YES;
				CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR;
				CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER = YES;
				CLANG_WARN_RANGE_LOOP_ANALYSIS = YES;
				CLANG_WARN_STRICT_PROTOTYPES = YES;
				CLANG_WARN_SUSPICIOUS_MOVE = YES;
				CLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE;
				CLANG_WARN_UNREACHABLE_CODE = YES;
				CLANG_WARN__DUPLICATE_METHOD_MATCH = YES;
				COPY_PHASE_STRIP = NO;
				DEBUG_INFORMATION_FORMAT = dwarf;
				ENABLE_STRICT_OBJC_MSGSEND = YES;
				ENABLE_TESTABILITY = YES;
				ENABLE_USER_SCRIPT_SANDBOXING = YES;
				GCC_C_LANGUAGE_STANDARD = gnu17;
				GCC_DYNAMIC_NO_PIC = NO;
				GCC_NO_COMMON_BLOCKS = YES;
				GCC_OPTIMIZATION_LEVEL = 0;
				GCC_PREPROCESSOR_DEFINITIONS = (
					"DEBUG=1",
					"$(inherited)",
				);
				GCC_WARN_64_TO_32_BIT_CONVERSION = YES;
				GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;
				GCC_WARN_UNDECLARED_SELECTOR = YES;
				GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;
				GCC_WARN_UNUSED_FUNCTION = YES;
				GCC_WARN_UNUSED_VARIABLE = YES;
				LOCALIZATION_PREFERS_STRING_CATALOGS = YES;
				MACOSX_DEPLOYMENT_TARGET = 13.0;
				MTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE;
				MTL_FAST_MATH = YES;
				ONLY_ACTIVE_ARCH = YES;
				SDKROOT = macosx;
				SWIFT_ACTIVE_COMPILATION_CONDITIONS = "DEBUG $(inherited)";
				SWIFT_OPTIMIZATION_LEVEL = "-Onone";
			};
			name = Debug;
		};
		$BUILD_CONFIG_RELEASE_UUID /* Release */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ALWAYS_SEARCH_USER_PATHS = NO;
				ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS = YES;
				CLANG_ANALYZER_NONNULL = YES;
				CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE;
				CLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				CLANG_ENABLE_OBJC_WEAK = YES;
				CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES;
				CLANG_WARN_BOOL_CONVERSION = YES;
				CLANG_WARN_COMMA = YES;
				CLANG_WARN_CONSTANT_CONVERSION = YES;
				CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES;
				CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR;
				CLANG_WARN_DOCUMENTATION_COMMENTS = YES;
				CLANG_WARN_EMPTY_BODY = YES;
				CLANG_WARN_ENUM_CONVERSION = YES;
				CLANG_WARN_INFINITE_RECURSION = YES;
				CLANG_WARN_INT_CONVERSION = YES;
				CLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES;
				CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES;
				CLANG_WARN_OBJC_LITERAL_CONVERSION = YES;
				CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR;
				CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER = YES;
				CLANG_WARN_RANGE_LOOP_ANALYSIS = YES;
				CLANG_WARN_STRICT_PROTOTYPES = YES;
				CLANG_WARN_SUSPICIOUS_MOVE = YES;
				CLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE;
				CLANG_WARN_UNREACHABLE_CODE = YES;
				CLANG_WARN__DUPLICATE_METHOD_MATCH = YES;
				COPY_PHASE_STRIP = NO;
				DEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";
				ENABLE_NS_ASSERTIONS = NO;
				ENABLE_STRICT_OBJC_MSGSEND = YES;
				ENABLE_USER_SCRIPT_SANDBOXING = YES;
				GCC_C_LANGUAGE_STANDARD = gnu17;
				GCC_NO_COMMON_BLOCKS = YES;
				GCC_WARN_64_TO_32_BIT_CONVERSION = YES;
				GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;
				GCC_WARN_UNDECLARED_SELECTOR = YES;
				GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;
				GCC_WARN_UNUSED_FUNCTION = YES;
				GCC_WARN_UNUSED_VARIABLE = YES;
				LOCALIZATION_PREFERS_STRING_CATALOGS = YES;
				MACOSX_DEPLOYMENT_TARGET = 13.0;
				MTL_ENABLE_DEBUG_INFO = NO;
				MTL_FAST_MATH = YES;
				SDKROOT = macosx;
				SWIFT_COMPILATION_MODE = wholemodule;
			};
			name = Release;
		};
		${BUILD_CONFIG_DEBUG_UUID}A /* Debug */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
				ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor;
				CODE_SIGN_ENTITLEMENTS = Resources/TidyFinder.entitlements;
				CODE_SIGN_STYLE = Automatic;
				COMBINE_HIDPI_IMAGES = YES;
				CURRENT_PROJECT_VERSION = 1;
				DEVELOPMENT_TEAM = "";
				ENABLE_HARDENED_RUNTIME = YES;
				ENABLE_PREVIEWS = YES;
				GENERATE_INFOPLIST_FILE = NO;
				INFOPLIST_FILE = Resources/Info.plist;
				INFOPLIST_KEY_NSHumanReadableCopyright = "Copyright © 2025 Scott Dix. All rights reserved.";
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/../Frameworks",
				);
				MARKETING_VERSION = 1.0.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.scottdix.TidyFinder;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = 5.0;
			};
			name = Debug;
		};
		${BUILD_CONFIG_RELEASE_UUID}A /* Release */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
				ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor;
				CODE_SIGN_ENTITLEMENTS = Resources/TidyFinder.entitlements;
				CODE_SIGN_STYLE = Automatic;
				COMBINE_HIDPI_IMAGES = YES;
				CURRENT_PROJECT_VERSION = 1;
				DEVELOPMENT_TEAM = "";
				ENABLE_HARDENED_RUNTIME = YES;
				ENABLE_PREVIEWS = YES;
				GENERATE_INFOPLIST_FILE = NO;
				INFOPLIST_FILE = Resources/Info.plist;
				INFOPLIST_KEY_NSHumanReadableCopyright = "Copyright © 2025 Scott Dix. All rights reserved.";
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/../Frameworks",
				);
				MARKETING_VERSION = 1.0.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.scottdix.TidyFinder;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = 5.0;
			};
			name = Release;
		};
		${BUILD_CONFIG_DEBUG_UUID}B /* Debug */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				BUNDLE_LOADER = "$(TEST_HOST)";
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				DEVELOPMENT_TEAM = "";
				GENERATE_INFOPLIST_FILE = YES;
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/../Frameworks",
					"@loader_path/../Frameworks",
				);
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.scottdix.TidyFinderTests;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SWIFT_EMIT_LOC_STRINGS = NO;
				SWIFT_VERSION = 5.0;
				TEST_HOST = "$(BUILT_PRODUCTS_DIR)/TidyFinder.app/$(BUNDLE_EXECUTABLE_FOLDER_PATH)/TidyFinder";
			};
			name = Debug;
		};
		${BUILD_CONFIG_RELEASE_UUID}B /* Release */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				BUNDLE_LOADER = "$(TEST_HOST)";
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				DEVELOPMENT_TEAM = "";
				GENERATE_INFOPLIST_FILE = YES;
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/../Frameworks",
					"@loader_path/../Frameworks",
				);
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.scottdix.TidyFinderTests;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SWIFT_EMIT_LOC_STRINGS = NO;
				SWIFT_VERSION = 5.0;
				TEST_HOST = "$(BUILT_PRODUCTS_DIR)/TidyFinder.app/$(BUNDLE_EXECUTABLE_FOLDER_PATH)/TidyFinder";
			};
			name = Release;
		};
/* End XCBuildConfiguration section */

/* Begin XCConfigurationList section */
		$BUILD_CONFIG_LIST_PROJECT_UUID /* Build configuration list for PBXProject "TidyFinder" */ = {
			isa = XCConfigurationList;
			buildConfigurations = (
				$BUILD_CONFIG_DEBUG_UUID /* Debug */,
				$BUILD_CONFIG_RELEASE_UUID /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		};
		$BUILD_CONFIG_LIST_APP_UUID /* Build configuration list for PBXNativeTarget "TidyFinder" */ = {
			isa = XCConfigurationList;
			buildConfigurations = (
				${BUILD_CONFIG_DEBUG_UUID}A /* Debug */,
				${BUILD_CONFIG_RELEASE_UUID}A /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		};
		$BUILD_CONFIG_LIST_TEST_UUID /* Build configuration list for PBXNativeTarget "TidyFinderTests" */ = {
			isa = XCConfigurationList;
			buildConfigurations = (
				${BUILD_CONFIG_DEBUG_UUID}B /* Debug */,
				${BUILD_CONFIG_RELEASE_UUID}B /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		};
/* End XCConfigurationList section */
	};
	rootObject = $PROJECT_UUID /* Project object */;
}
EOF

# Create workspace settings
echo "📝 Creating workspace settings..."
cat > "$PROJECT_DIR/$PROJECT_NAME.xcodeproj/project.xcworkspace/contents.xcworkspacedata" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<Workspace
   version = "1.0">
   <FileRef
      location = "self:">
   </FileRef>
</Workspace>
EOF

cat > "$PROJECT_DIR/$PROJECT_NAME.xcodeproj/project.xcworkspace/xcshareddata/IDEWorkspaceChecks.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>IDEDidComputeMac32BitWarning</key>
	<true/>
</dict>
</plist>
EOF

# Create a basic scheme
echo "📝 Creating Xcode scheme..."
cat > "$PROJECT_DIR/$PROJECT_NAME.xcodeproj/xcshareddata/xcschemes/TidyFinder.xcscheme" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<Scheme
   LastUpgradeVersion = "1500"
   version = "1.7">
   <BuildAction
      parallelizeBuildables = "YES"
      buildImplicitDependencies = "YES">
      <BuildActionEntries>
         <BuildActionEntry
            buildForTesting = "YES"
            buildForRunning = "YES"
            buildForProfiling = "YES"
            buildForArchiving = "YES"
            buildForAnalyzing = "YES">
            <BuildableReference
               BuildableIdentifier = "primary"
               BlueprintIdentifier = "$APP_TARGET_UUID"
               BuildableName = "TidyFinder.app"
               BlueprintName = "TidyFinder"
               ReferencedContainer = "container:TidyFinder.xcodeproj">
            </BuildableReference>
         </BuildActionEntry>
      </BuildActionEntries>
   </BuildAction>
   <TestAction
      buildConfiguration = "Debug"
      selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB"
      selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB"
      shouldUseLaunchSchemeArgsEnv = "YES">
      <Testables>
         <TestableReference
            skipped = "NO">
            <BuildableReference
               BuildableIdentifier = "primary"
               BlueprintIdentifier = "$TEST_TARGET_UUID"
               BuildableName = "TidyFinderTests.xctest"
               BlueprintName = "TidyFinderTests"
               ReferencedContainer = "container:TidyFinder.xcodeproj">
            </BuildableReference>
         </TestableReference>
      </Testables>
   </TestAction>
   <LaunchAction
      buildConfiguration = "Debug"
      selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB"
      selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB"
      launchStyle = "0"
      useCustomWorkingDirectory = "NO"
      ignoresPersistentStateOnLaunch = "NO"
      debugDocumentVersioning = "YES"
      debugServiceExtension = "internal"
      allowLocationSimulation = "YES">
      <BuildableProductRunnable
         runnableDebuggingMode = "0">
         <BuildableReference
            BuildableIdentifier = "primary"
            BlueprintIdentifier = "$APP_TARGET_UUID"
            BuildableName = "TidyFinder.app"
            BlueprintName = "TidyFinder"
            ReferencedContainer = "container:TidyFinder.xcodeproj">
         </BuildableReference>
      </BuildableProductRunnable>
   </LaunchAction>
   <ProfileAction
      buildConfiguration = "Release"
      shouldUseLaunchSchemeArgsEnv = "YES"
      savedToolIdentifier = ""
      useCustomWorkingDirectory = "NO"
      debugDocumentVersioning = "YES">
      <BuildableProductRunnable
         runnableDebuggingMode = "0">
         <BuildableReference
            BuildableIdentifier = "primary"
            BlueprintIdentifier = "$APP_TARGET_UUID"
            BuildableName = "TidyFinder.app"
            BlueprintName = "TidyFinder"
            ReferencedContainer = "container:TidyFinder.xcodeproj">
         </BuildableReference>
      </BuildableProductRunnable>
   </ProfileAction>
   <AnalyzeAction
      buildConfiguration = "Debug">
   </AnalyzeAction>
   <ArchiveAction
      buildConfiguration = "Release"
      revealArchiveInOrganizer = "YES">
   </ArchiveAction>
</Scheme>
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
EOF

echo "✅ Success! TidyFinder Xcode project has been manually generated at:"
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
echo ""
echo "⚠️  Note: This is a manually generated project. Some advanced features"
echo "    may require additional configuration in Xcode."