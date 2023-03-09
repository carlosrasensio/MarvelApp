//
//  FavoritesViewModel.swift
//  MarvelApp
//
//  Created by crodrigueza on 22/2/22.
//

import Foundation
import RxSwift

protocol FavoritesViewModelProtocol {
  var view: FavoritesViewControllerProtocol? { get }
  var router: FavoritesRouterProtocol? { get }
  var coreDataManager: CoreDataManagerProtocol? { get }
  func bind(view: FavoritesViewControllerProtocol, router: FavoritesRouterProtocol, coreDataManager: CoreDataManagerProtocol)
  func getCoreDataFavorites() -> [Character]
  func deleteFavorite(_ name: String)
  func createCharacterDetailView(_ character: Character)
}

final class FavoritesViewModel: FavoritesViewModelProtocol {
  // MARK: Variables
  var view: FavoritesViewControllerProtocol?
  var router: FavoritesRouterProtocol?
  var coreDataManager: CoreDataManagerProtocol?
  
  // MARK: Connecting view and router
  func bind(view: FavoritesViewControllerProtocol, router: FavoritesRouterProtocol, coreDataManager: CoreDataManagerProtocol) {
    self.view = view
    self.router = router
    self.coreDataManager = coreDataManager
    self.router?.setSourceView(view as? UIViewController)
  }
  
  // MARK: Data manager
  func getCoreDataFavorites() -> [Character] {
    guard let coreDataManager else { return [Character]() }
    return coreDataManager.getCoreDataFavorites()
  }
  
  func deleteFavorite(_ name: String) {
    guard let coreDataManager else { return }
    coreDataManager.deleteFavorite(name)
  }
  
  // MARK: Navigation
  func createCharacterDetailView(_ character: Character) {
    router?.navigateToCharacterDetail(character)
  }
}
