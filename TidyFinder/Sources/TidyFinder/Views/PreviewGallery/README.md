# Preview Gallery Components

This directory contains the visual preview components for TidyFinder that show mockups of each Finder view style.

## Components

### PreviewGalleryView.swift
The main view that displays all four preview styles in a 2x2 grid. Features:
- Interactive preview cards that respond to hover and selection
- Integration with ContentViewModel for view style management
- Visual feedback for the currently selected style

### Individual Preview Components

#### IconViewPreview.swift
Shows a grid layout of files and folders as they appear in Finder's Icon view:
- 6 sample items (3 folders, 3 files)
- Uses SF Symbols for file type icons
- Interactive hover and selection states
- Responsive grid layout

#### ListViewPreview.swift
Displays a table-like list view with columns:
- Name, Date Modified, and Size columns
- Sortable header appearance
- Row highlighting on hover/selection
- Authentic Finder styling

#### ColumnViewPreview.swift
Shows the multi-column browser style:
- Three columns with hierarchical navigation
- Chevron indicators for folders
- Column-based selection
- Miller columns layout

#### GalleryViewPreview.swift
Displays large thumbnail previews:
- Larger preview tiles
- Colored placeholders for different file types
- Shadow effects on hover
- Grid layout optimized for media files

## Usage

The preview gallery is integrated into the main ContentView and appears between the view style picker and the Finder options. Users can:

1. **View all styles at a glance** - See how each view style looks before selecting
2. **Click to select** - Clicking any preview immediately changes the selected view style
3. **Hover for feedback** - Visual feedback shows which preview is being hovered over
4. **See current selection** - The currently selected style is highlighted with an accent color border

## Styling

All preview components follow macOS design guidelines:
- Native color schemes that adapt to light/dark mode
- Authentic Finder window chrome (traffic light buttons)
- Proper spacing and typography
- Smooth animations and transitions

## Integration

The preview gallery is fully integrated with the existing ContentViewModel:
- Selections in the gallery update the view model
- Changes to the view model update the gallery selection
- All state management is handled through the existing infrastructure