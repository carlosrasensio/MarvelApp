//
//  FavoritesRouter.swift
//  MarvelApp
//
//  Created by crodrigueza on 22/2/22.
//

import Foundation
import UIKit

protocol FavoritesRouterProtocol {
    var favorites: [Character] { get }
    func createFavoritesViewController() -> UIViewController
    func setSourceView(_  sourceView: UIViewController?)
    func navigateToCharacterDetail(_ character: Character)
}

final class FavoritesRouter: FavoritesRouterProtocol {
    // MARK: - Variables
    private var sourceView: UIViewController?
    var viewController: UIViewController {
        createFavoritesViewController()
    }
    var favorites: [Character]

    // MARK: - Initializer
    init(favorites: [Character] = []) {
        self.favorites = favorites
    }

    // MARK: - Configuration functions
    func createFavoritesViewController() -> UIViewController {
        let view = FavoritesViewController(nibName: "FavoritesViewController", bundle: Bundle.main)
        view.favorites = favorites

        return view
    }

    func setSourceView(_  sourceView: UIViewController?) {
        guard let view = sourceView else { return }
        self.sourceView = view
    }

    // MARK: - Navigation function
    func navigateToCharacterDetail(_ character: Character) {
        let characterDetailView = CharacterDetailRouter(character: character, isHiddenFavoriteButton: true).viewController
        sourceView?.navigationController?.pushViewController(characterDetailView, animated: true)
    }
}
