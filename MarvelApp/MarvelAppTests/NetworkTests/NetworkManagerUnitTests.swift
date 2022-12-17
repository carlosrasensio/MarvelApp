//
//  NetworkManagerUnitTests.swift
//  MarvelAppTests
//
//  Created by crodrigueza on 18/2/22.
//

import XCTest
@testable import MarvelApp

class NetworkManagerUnitTests: XCTestCase {
    var networkManager: NetworkManager!

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        networkManager = nil
        try super.tearDownWithError()
    }

    func testNetworkManagerResponseIsNotNil() {
        networkManager = NetworkManager()
        let response = networkManager.getCharacters(offset: 50)
        XCTAssertNotNil(response)
    }
}
