//
//  Twitter_TweetsUITests.swift
//  Twitter TweetsUITests
//
//  Created by Ivan Raychev on 4.12.20.
//  Copyright © 2020 Ivan Raychev. All rights reserved.
//

import XCTest

class Twitter_TweetsUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testSearch() {
        XCTAssertFalse(app.tables.element.cells.firstMatch.exists)
        let searchField = app.searchFields.element
        searchField.tap()
        searchField.typeText("test\n")
        XCTAssert(app.tables.element.cells.firstMatch.waitForExistence(timeout: 3))
    }
    
}
