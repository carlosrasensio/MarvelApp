//
//  Character.swift
//  MarvelApp
//
//  Created by crodrigueza on 17/2/22.
//

import Foundation

struct Character: Codable, Equatable {
    let name: String
    let description: String
    let thumbnail: Thumbnail

    static func == (lhs: Character, rhs: Character) -> Bool {
        return lhs.name == rhs.name &&
            lhs.description == rhs.description &&
            lhs.thumbnail == rhs.thumbnail
    }
}

struct Thumbnail: Codable, Equatable {
    let path: String
    let imageExtension: String

    enum CodingKeys: String, CodingKey {
        case path
        case imageExtension = "extension"
    }
}
