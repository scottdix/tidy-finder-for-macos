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
        WindowGroup("TidyFinder - Organize Your Finder") {
            ContentView()
                .onAppear {
                    // Ensure the window appears in the center of the screen
                    NSApplication.shared.windows.first?.center()
                }
        }
        .windowStyle(.automatic)
        .windowResizability(.contentSize)
        .commands {
            // Add menu commands for keyboard shortcuts
            CommandGroup(replacing: .appInfo) {
                Button("About TidyFinder") {
                    NSApplication.shared.orderFrontStandardAboutPanel(nil)
                }
            }
            
            CommandMenu("Actions") {
                Button("Relaunch Finder") {
                    NotificationCenter.default.post(
                        name: Notification.Name("RelaunchFinder"),
                        object: nil
                    )
                }
                .keyboardShortcut("r", modifiers: .command)
                
                Button("Apply to All Folders") {
                    NotificationCenter.default.post(
                        name: Notification.Name("ApplyToAllFolders"),
                        object: nil
                    )
                }
                .keyboardShortcut("a", modifiers: [.command, .shift])
            }
        }
    }
}
