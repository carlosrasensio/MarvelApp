//
//  MarvelAppUITests.swift
//  MarvelAppUITests
//
//  Created by crodrigueza on 16/2/22.
//

import XCTest

class MarvelAppUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testFavoritesButtonPressed() throws {
        let app = XCUIApplication()
        app.launch()
        let favoritesButton = app.buttons["favoritesButton"]
        favoritesButton.tap()
        // TODO: test Favorites list counts +1
    }
}
