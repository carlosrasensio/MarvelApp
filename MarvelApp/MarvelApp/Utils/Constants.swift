//
//  Constants.swift
//  MarvelApp
//
//  Created by crodrigueza on 16/2/22.
//

import Foundation

struct Constants {
    static let appName = "MARVEL App"
    static let appIcon = "icnMarvel"

    struct NetworkManager {
        static let version = 1
        static let type = "public"
        static let timeStamp = Date().timeIntervalSince1970
        static let publicApiKey = "bdd7f1b10e8f1b342807f0d5a01f3e03"
        static let privateApiKey = ""   // TODO: Insert private api key
        static let limit = 50

        struct URLs {
            static let base = "https://gateway.marvel.com/"
        }

        struct Endpoints {
            static let version = "v\(NetworkManager.version)/"
            static let type = "\(NetworkManager.type)/"
            static let characters = "characters"
        }

        struct Image {
            let variant: Variant
            
            enum Variant: String {
                case portrait_small
                case portrait_medium
                case portrait_xlarge
                case portrait_fantastic
                case portrait_ucanny
                case portrait_incredible
                case landscape_small
                case landscape_medium
                case landscape_large
                case landscape_xlarge
                case landscape_amazing
                case landscape_incredible
            }
        }
    }

    struct CustomCells {
        static let characterCellId = "CharacterCustomCell"
    }
}
