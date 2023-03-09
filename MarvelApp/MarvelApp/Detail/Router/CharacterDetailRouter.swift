//
//  CharacterDetailRouter.swift
//  MarvelApp
//
//  Created by crodrigueza on 16/2/22.
//

import Foundation
import UIKit

protocol CharacterDetailRouterProtocol {
  func createCharacterDetailViewController() -> UIViewController
  func setSourceView(_  sourceView: UIViewController?)
}

final class CharacterDetailRouter {
  // MARK: Variables
  private var sourceView: UIViewController?
  var viewController: UIViewController {
    createCharacterDetailViewController()
  }
  var character: Character?
  var isHiddenFavoriteButton: Bool
  
  // MARK: Initializer
  init(character: Character? = nil, isHiddenFavoriteButton: Bool = false) {
    self.character = character
    self.isHiddenFavoriteButton = isHiddenFavoriteButton
  }
}

// MARK: - CharacterDetailRouterProtocol

extension CharacterDetailRouter: CharacterDetailRouterProtocol {
  func createCharacterDetailViewController() -> UIViewController {
    let view = CharacterDetailViewController(router: CharacterDetailRouter(), viewModel: CharacterDetailViewModel(), coreDataManager: CoreDataManager())
    view.character = character
    view.isHiddenFavoriteButton = isHiddenFavoriteButton
    
    return view
  }
  
  func setSourceView(_  sourceView: UIViewController?) {
    guard let view = sourceView else { return }
    self.sourceView = view
  }
}
