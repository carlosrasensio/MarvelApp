//
//  CharacterDetailViewModel.swift
//  MarvelApp
//
//  Created by crodrigueza on 16/2/22.
//

import Foundation
import RxSwift

protocol CharacterDetailViewModelProtocol {
  var view: CharacterDetailViewControllerProtocol? { get }
  var router: CharacterDetailRouterProtocol? { get }
  var coreDataManager: CoreDataManagerProtocol? { get }
  func bind(view: CharacterDetailViewControllerProtocol, router: CharacterDetailRouterProtocol, coreDataManager: CoreDataManagerProtocol)
  func saveFavorite(_ favorite: Character)
}

final class CharacterDetailViewModel: CharacterDetailViewModelProtocol {
  // MARK: Variables
  var view: CharacterDetailViewControllerProtocol?
  var router: CharacterDetailRouterProtocol?
  var coreDataManager: CoreDataManagerProtocol?
  
  // MARK: Connecting view and router
  func bind(view: CharacterDetailViewControllerProtocol, router: CharacterDetailRouterProtocol, coreDataManager: CoreDataManagerProtocol) {
    self.view = view
    self.router = router
    self.coreDataManager = coreDataManager
    self.router?.setSourceView(view as? UIViewController)
  }
  
  func saveFavorite(_ favorite: Character) {
    guard let coreDataManager else { return }
    coreDataManager.saveFavorite(favorite)
  }
}
