//
//  CharacterDataWrapper.swift
//  MarvelApp
//
//  Created by crodrigueza on 17/2/22.
//

import Foundation

struct CharacterDataWrapper: Codable, Equatable {
    let data: CharacterDataContainer

    static func == (lhs: CharacterDataWrapper, rhs: CharacterDataWrapper) -> Bool {
        return lhs.data == rhs.data
    }
}
