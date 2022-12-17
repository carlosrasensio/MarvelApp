//
//  CharacterDetailRouter.swift
//  MarvelApp
//
//  Created by crodrigueza on 16/2/22.
//

import Foundation
import UIKit

protocol CharacterDetailRouterProtocol {
    var character: Character? { get }
    func createCharacterDetailViewController() -> UIViewController
    func setSourceView(_  sourceView: UIViewController?)
}

final class CharacterDetailRouter: CharacterDetailRouterProtocol {
    // MARK: - Variables
    private var sourceView: UIViewController?
    var viewController: UIViewController {
        createCharacterDetailViewController()
    }
    var character: Character?
    var isHiddenFavoriteButton: Bool

    // MARK: - Initializer
    init(character: Character? = nil, isHiddenFavoriteButton: Bool = false) {
        self.character = character
        self.isHiddenFavoriteButton = isHiddenFavoriteButton
    }

    // MARK: - Configuration functions
    func createCharacterDetailViewController() -> UIViewController {
        let view = CharacterDetailViewController(nibName: "CharacterDetailViewController", bundle: Bundle.main)
        view.character = character
        view.isHiddenFavoriteButton = isHiddenFavoriteButton

        return view
    }

    func setSourceView(_  sourceView: UIViewController?) {
        guard let view = sourceView else { return }
        self.sourceView = view
    }
}
