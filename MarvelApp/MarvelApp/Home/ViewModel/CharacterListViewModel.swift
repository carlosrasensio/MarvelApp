//
//  CharacterListViewModel.swift
//  MarvelApp
//
//  Created by crodrigueza on 16/2/22.
//

import Foundation
import RxSwift

protocol CharacterListViewModelProtocol {
  var view: CharacterListViewControllerProtocol? { get }
  var router: CharacterListRouterProtocol? { get }
  var networkManager: NetworkManagerProtocol? { get }
  func bind(view: CharacterListViewControllerProtocol, router: CharacterListRouterProtocol, networkManager: NetworkManagerProtocol)
  func getCharacters(offset: Int) -> Observable<[Character]>
  func createCharacterDetailView(_ character: Character)
  func createFavoritesView()
}

final class CharacterListViewModel: CharacterListViewModelProtocol {
  // MARK: Variables
  var view: CharacterListViewControllerProtocol?
  var router: CharacterListRouterProtocol?
  var networkManager: NetworkManagerProtocol?

  // MARK: Connecting view and router
  func bind(view: CharacterListViewControllerProtocol, router: CharacterListRouterProtocol, networkManager: NetworkManagerProtocol) {
    self.view = view
    self.router = router
    self.router?.setSourceView(view as? UIViewController)
    self.networkManager = networkManager
  }
  
  // MARK: Get data from service
  func getCharacters(offset: Int) -> Observable<[Character]> {
    return networkManager!.getCharacters(offset: offset)
  }
  
  // MARK: Navigation
  func createCharacterDetailView(_ character: Character) {
    router?.navigateToCharacterDetail(character)
  }
  
  func createFavoritesView() {
    router?.navigateToFavoritesView()
  }
}
