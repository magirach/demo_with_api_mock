//
//  last_fm_searchUITests.swift
//  last_fm_searchUITests
//
//  Created by Moinuddin Girach on 17/06/20.
//  Copyright © 2020 Moinuddin Girach. All rights reserved.
//

import XCTest

class last_fm_searchUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
       let app = XCUIApplication()
        app.launch()
        app.searchFields.firstMatch.tap()
        app.keyboards.buttons["Search"].tap()
        app.searchFields.firstMatch.tap()
        app.keyboards.keys["A"].tap()
        app.keyboards.keys["a"].tap()
        let table = app.tables.firstMatch
        wait(element: table, type: "exist", duration: 5)
        let albumNameExists = app.tables.cells.firstMatch.staticTexts["Wolfgang Amadeus Phoenix"].exists
        XCTAssert(albumNameExists, "Albun does not exist")
        let artistNameExist = app.tables.cells.firstMatch.staticTexts["Phoenix"].exists
        XCTAssert(artistNameExist, "Artist does not exist")
        table.cells.firstMatch.tap()
        XCTAssert(albumNameExists, "Albun does not exist")
        XCTAssert(artistNameExist, "Artist does not exist")
        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    @discardableResult
    func wait(element:XCUIElement, type: String, duration: Int) -> Bool {
        let predicate = NSPredicate(format: "\(type) == true")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: element)
        let result = XCTWaiter().wait(for: [expectation], timeout: TimeInterval(duration))
        switch result {
        case .completed:
            return true
        default:
            return false
        }
    }
}
