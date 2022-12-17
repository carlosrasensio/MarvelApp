//
//  CharacterUnitTests.swift
//  MarvelAppTests
//
//  Created by crodrigueza on 18/2/22.
//

import XCTest
@testable import MarvelApp

class CharacterUnitTests: XCTestCase, DecodableTestCase {
    var sut: CharacterDataWrapper!

    override func setUpWithError() throws {
        try super.setUpWithError()
        try! givenSUTFromJSON(fileName: "MockCharacters")
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testConformsToDecodable() {
        XCTAssertTrue((sut as Any) is Decodable)
    }

    func testConformsToEquatable() {
        XCTAssertEqual(sut, sut)
    }

    func testDecodableSetsImagePath() {
        XCTAssertEqual(sut.data.results[1].thumbnail.path, "http://i.annihil.us/u/prod/marvel/i/mg/3/20/5232158de5b16")
    }

    func testDecodableSetsImageExtension() {
        XCTAssertEqual(sut.data.results[1].thumbnail.imageExtension, "jpg")
    }

    func testDecodableSetsName() {
        XCTAssertEqual(sut.data.results[1].name, "A-Bomb (HAS)")
    }

    func testDecodableSetsDescription() {
        XCTAssertEqual(sut.data.results[1].description, "Rick Jones has been Hulk's best bud since day one, but now he's more than a friend...he's a teammate! Transformed by a Gamma energy explosion, A-Bomb's thick, armored skin is just as strong and powerful as it is blue. And when he curls into action, he uses it like a giant bowling ball of destruction! ")
    }
}
