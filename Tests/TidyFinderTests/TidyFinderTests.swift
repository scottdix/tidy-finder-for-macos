import XCTest
@testable import TidyFinderCore

final class TidyFinderTests: XCTestCase {
    func testViewStyleRawValues() {
        XCTAssertEqual(FinderManager.ViewStyle.list.rawValue, "Nlsv")
        XCTAssertEqual(FinderManager.ViewStyle.icon.rawValue, "icnv")
        XCTAssertEqual(FinderManager.ViewStyle.column.rawValue, "clmv")
        XCTAssertEqual(FinderManager.ViewStyle.gallery.rawValue, "glyv")
    }
    
    func testViewStyleDisplayNames() {
        XCTAssertEqual(FinderManager.ViewStyle.list.displayName, "List")
        XCTAssertEqual(FinderManager.ViewStyle.icon.displayName, "Icon")
        XCTAssertEqual(FinderManager.ViewStyle.column.displayName, "Column")
        XCTAssertEqual(FinderManager.ViewStyle.gallery.displayName, "Gallery")
    }
    
    func testFinderOptionRawValues() {
        XCTAssertEqual(FinderManager.FinderOption.showPathBar.rawValue, "ShowPathbar")
        XCTAssertEqual(FinderManager.FinderOption.showStatusBar.rawValue, "ShowStatusBar")
        XCTAssertEqual(FinderManager.FinderOption.showSidebar.rawValue, "ShowSidebar")
        XCTAssertEqual(FinderManager.FinderOption.showPreviewPane.rawValue, "ShowPreviewPane")
    }
}