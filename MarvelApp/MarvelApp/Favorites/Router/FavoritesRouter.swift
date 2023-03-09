//
//  FavoritesRouter.swift
//  MarvelApp
//
//  Created by crodrigueza on 22/2/22.
//

import Foundation
import UIKit

protocol FavoritesRouterProtocol {
  func createFavoritesViewController() -> UIViewController
  func setSourceView(_  sourceView: UIViewController?)
  func navigateToCharacterDetail(_ character: Character)
}

final class FavoritesRouter {
  // MARK: Variables
  private var sourceView: UIViewController?
  var viewController: UIViewController {
    createFavoritesViewController()
  }
  var favorites: [Character]
  
  // MARK: Initializer
  init(favorites: [Character] = []) {
    self.favorites = favorites
  }
}

// MARK: - FavoritesRouterProtocol

extension FavoritesRouter: FavoritesRouterProtocol {
  func createFavoritesViewController() -> UIViewController {
    let view = FavoritesViewController(router: FavoritesRouter(), viewModel: FavoritesViewModel(), coreDataManager: CoreDataManager())
    view.favorites = favorites
    
    return view
  }
  
  func setSourceView(_  sourceView: UIViewController?) {
    guard let view = sourceView else { return }
    self.sourceView = view
  }
  
  func navigateToCharacterDetail(_ character: Character) {
    let characterDetailView = CharacterDetailRouter(character: character, isHiddenFavoriteButton: true).viewController
    sourceView?.navigationController?.pushViewController(characterDetailView, animated: true)
  }
}
