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
  var dataManager: DataManagerProtocol? { get }
  func bind(view: FavoritesViewControllerProtocol, router: FavoritesRouterProtocol, dataManager: DataManagerProtocol)
  func getCoreDataFavorites() -> [Character]
  func deleteFavorite(_ name: String)
  func createCharacterDetailView(_ character: Character)
}

final class FavoritesViewModel: FavoritesViewModelProtocol {
  // MARK: Variables
  var view: FavoritesViewControllerProtocol?
  var router: FavoritesRouterProtocol?
  var dataManager: DataManagerProtocol?
  
  // MARK: Connecting view and router
  func bind(view: FavoritesViewControllerProtocol, router: FavoritesRouterProtocol, dataManager: DataManagerProtocol) {
    self.view = view
    self.router = router
    self.dataManager = dataManager
    self.router?.setSourceView(view as? UIViewController)
  }
  
  // MARK: Data manager
  func getCoreDataFavorites() -> [Character] {
    guard let dataManager else { return [Character]() }
  
    return dataManager.getCoreDataFavorites()
  }
  
  func deleteFavorite(_ name: String) {
    guard let dataManager else { return }
    dataManager.deleteFavorite(name)
  }
  
  // MARK: Navigation
  func createCharacterDetailView(_ character: Character) {
    router?.navigateToCharacterDetail(character)
  }
}
