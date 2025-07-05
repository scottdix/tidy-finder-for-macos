# Prototype Development Plan: TidyFinder

This document outlines a 4-sprint plan to develop a working prototype of the TidyFinder application, based on the established functional requirements. Each sprint is designed to be completed in approximately one week.

## Sprint 1: Core Logic & Backend Foundation

**Goal**: Create the non-visual, backend Swift code that can execute all necessary shell commands. At the end of this sprint, we will have a command-line tool that can perform all the app's core functions.

### Task 1.1: Project Setup

- Create a new public GitHub repository named TidyFinder.
- Initialize a new Xcode project for a macOS Command Line Tool. This keeps focus on the logic, not the UI.

### Task 1.2: Create a Shell Command Executor

Implement a Swift class or struct (e.g., `ShellRunner`) with a single, reusable function.

**Function**: `execute(command: String)`

**Details**: This function will use Swift's `Process` class to run any given shell command. It should be able to handle basic output and errors, printing them to the console for now.

### Task 1.3: Develop the Finder Manager

Create the main logic class: `FinderManager`.

**Function**: `setDefaultViewStyle(to style: ViewStyle)`

**Details**: Use a Swift enum for `ViewStyle` (e.g., `.list`, `.icon`, `.column`, `.gallery`). The function will build the correct `defaults write com.apple.finder FXPreferredViewStyle -string "CODE"` command and execute it using the `ShellRunner`.

**Function**: `setGlobalOption(_ option: FinderOption, to value: Bool)`

**Details**: Use an enum for `FinderOption` (e.g., `.showPathBar`, `.showStatusBar`). The function will build the correct `defaults write com.apple.finder ...` command.

**Function**: `resetAllExistingViews()`

**Details**: This function will build and execute the `find ~ -name ".DS_Store" -depth -exec rm {} \;` command.

**Function**: `relaunchFinder()`

**Details**: This function will execute `killall Finder`.

**Sprint 1 Deliverable**: A command-line executable that can be run from Terminal to apply all the specified Finder settings.

## Sprint 2: UI Scaffolding & State Management

**Goal**: Build the visual user interface in SwiftUI and create a view model to manage its state. The UI will not be functional yet, but it will be visually complete and reflect the system's current settings on launch.

### Task 2.1: Transition to a GUI App

- Create a new project target in Xcode for a full macOS App using SwiftUI.
- Copy the `FinderManager` and `ShellRunner` code from Sprint 1 into this new app target.

### Task 2.2: Build the ContentView

In `ContentView.swift`, lay out the UI as defined in the FRD (Section 2.2):

- A `VStack` to organize the sections.
- A `Picker` for the default view style.
- The four `Toggle` switches for global options.
- The two `Button`s for the primary actions.
- Use native macOS styling to ensure it looks clean.

### Task 2.3: Create the View Model

- Create an `ObservableObject` class named `ViewModel`.
- Add `@Published` properties to hold the state for each UI control (e.g., `var selectedViewStyle: ViewStyle`, `var showPathBar: Bool`).

### Task 2.4: Implement Initial State Loading

- In the `ViewModel`, create an `init()` method.
- This initializer will use the `ShellRunner` to execute `defaults read com.apple.finder ...` commands for each setting.
- It will parse the output and set the initial values of the `@Published` properties.
- Bind the SwiftUI views to the `ViewModel` so the UI accurately reflects the user's current Finder settings when the app launches.

**Sprint 2 Deliverable**: A launchable app that displays the UI and correctly shows the current state of Finder's settings, but with non-functional buttons and controls.

## Sprint 3: Connecting UI to Logic

**Goal**: Activate the UI by connecting every button, picker, and toggle to the backend `FinderManager` logic.

### Task 3.1: Wire Up Controls

- Modify the `ViewModel` so that when any `@Published` property is changed by the UI, it calls the corresponding function in the `FinderManager`.
- Example: When the user selects "List" in the `Picker`, the `ViewModel` should call `finderManager.setDefaultViewStyle(to: .list)`.

### Task 3.2: Implement Action Buttons

- Connect the **Relaunch Finder** button's action to call `finderManager.relaunchFinder()` via the `ViewModel`.
- Connect the **Apply to All Existing Folders** button to a new function in the `ViewModel`.

### Task 3.3: Implement Confirmation Dialog

- Use a SwiftUI `.alert()` modifier on the main view.
- The alert's visibility will be bound to a `@State` boolean variable (e.g., `showAlert`).
- When the "Apply..." button is pressed, set `showAlert` to `true`.
- The alert will display the title and message from the FRD.
- Only if the user clicks the "Confirm" action in the alert, proceed to call `finderManager.resetAllExistingViews()`.

**Sprint 3 Deliverable**: A fully functional prototype. Every UI element works and performs its intended action.

## Sprint 4: Polishing, Packaging & Documentation

**Goal**: Refine the prototype, add an app icon, write documentation, and prepare it for the first public release on GitHub.

### Task 4.1: App Icon and Assets

- Design a simple, clear application icon.
- Add the icon to the Xcode project's Asset Catalog in all required sizes.

### Task 4.2: Final UI/UX Polish

- Review all spacing, padding, and text labels for clarity and consistency.
- Ensure the window has a sensible default size and is resizable.
- Add comments to the code to improve readability.

### Task 4.3: Write Documentation

- Create a comprehensive `README.md` file in the GitHub repository.
- Include: A project summary, a screenshot of the app, installation instructions (how to download from Releases), and simple usage instructions.

### Task 4.4: Archive and Release

- Configure the final build settings in Xcode (version 1.0.0).
- Use Xcode's "Archive" feature to create a distributable `.app` file.
- Create a new "Release" on the GitHub repository page.
- Upload the archived app (e.g., as a `.zip` file) to the release.

**Sprint 4 Deliverable**: A polished, distributable v1.0.0 of TidyFinder, publicly available on GitHub.