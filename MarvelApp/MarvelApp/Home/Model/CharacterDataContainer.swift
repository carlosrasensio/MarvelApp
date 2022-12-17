//
//  CharacterDataContainer.swift
//  MarvelApp
//
//  Created by crodrigueza on 17/2/22.
//

import Foundation

struct CharacterDataContainer: Codable, Equatable {
    let offset, limit, total, responseCount: Int
    let results: [Character]

    enum CodingKeys: String, CodingKey {
        case offset, limit, total
        case responseCount = "count"
        case results
    }

    static func == (lhs: CharacterDataContainer, rhs: CharacterDataContainer) -> Bool {
        return lhs.results == rhs.results
    }
}
