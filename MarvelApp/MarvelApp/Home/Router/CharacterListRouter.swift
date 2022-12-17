//
//  CharacterListRouter.swift
//  MarvelApp
//
//  Created by crodrigueza on 16/2/22.
//

import Foundation

import UIKit

protocol CharacterListRouterProtocol {
    func createCharacterListViewController() -> UIViewController
    func setSourceView(_  sourceView: UIViewController?)
    func navigateToCharacterDetail(_ character: Character)
    func navigateToFavoritesView()
}

final class CharacterListRouter: CharacterListRouterProtocol {
    // MARK: - Variables
    private var sourceView: UIViewController?
    var viewController: UIViewController {
        createCharacterListViewController()
    }

    // MARK: - Configuration functions
    func createCharacterListViewController() -> UIViewController {
        let view = CharacterListViewController(nibName: "CharacterListViewController", bundle: Bundle.main)

        return view
    }

    func setSourceView(_  sourceView: UIViewController?) {
        guard let view = sourceView else { return }
        self.sourceView = view
    }

    // MARK: - Navigation function
    func navigateToCharacterDetail(_ character: Character) {
        let characterDetailView = CharacterDetailRouter(character: character).viewController
        sourceView?.navigationController?.pushViewController(characterDetailView, animated: true)
    }

    func navigateToFavoritesView() {
        let favoritesView = FavoritesRouter().viewController
        sourceView?.navigationController?.pushViewController(favoritesView, animated: true)
    }
}
