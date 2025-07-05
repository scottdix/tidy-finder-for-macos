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
