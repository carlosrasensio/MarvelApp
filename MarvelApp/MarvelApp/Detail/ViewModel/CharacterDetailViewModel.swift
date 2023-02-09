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
  var dataManager: DataManagerProtocol? { get }
  func bind(view: CharacterDetailViewControllerProtocol, router: CharacterDetailRouterProtocol, dataManager: DataManagerProtocol)
  func saveFavorite(_ favorite: Character)
}

final class CharacterDetailViewModel: CharacterDetailViewModelProtocol {
  // MARK: Variables
  var view: CharacterDetailViewControllerProtocol?
  var router: CharacterDetailRouterProtocol?
  var dataManager : DataManagerProtocol?
  
  // MARK: Connecting view and router
  func bind(view: CharacterDetailViewControllerProtocol, router: CharacterDetailRouterProtocol, dataManager: DataManagerProtocol) {
    self.view = view
    self.router = router
    self.dataManager = dataManager
    self.router?.setSourceView(view as? UIViewController)
  }
  
  func saveFavorite(_ favorite: Character) {
    guard let dataManager else { return }
    dataManager.saveFavorite(favorite)
  }
}
