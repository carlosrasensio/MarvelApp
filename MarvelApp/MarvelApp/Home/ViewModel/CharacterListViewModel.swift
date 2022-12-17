//
//  CharacterListViewModel.swift
//  MarvelApp
//
//  Created by crodrigueza on 16/2/22.
//

import Foundation
import RxSwift

protocol CharacterListViewModelProtocol {
    var view: CharacterListViewController? { get }
    var router: CharacterListRouter? { get }
    func bind(view: CharacterListViewController, router: CharacterListRouter)
    func getCharacters(offset: Int) -> Observable<[Character]>
    func createCharacterDetailView(_ character: Character)
}

final class CharacterListViewModel: CharacterListViewModelProtocol {
    // MARK: - Variables
    weak var view: CharacterListViewController?
    var router: CharacterListRouter?
    private var networkManager = NetworkManager()

    // MARK: - Connecting view and router
    func bind(view: CharacterListViewController, router: CharacterListRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }

    // MARK: - Get data from service
    func getCharacters(offset: Int) -> Observable<[Character]> {
        return networkManager.getCharacters(offset: offset)
    }

    // MARK: - Navigation
    func createCharacterDetailView(_ character: Character) {
        router?.navigateToCharacterDetail(character)
    }

    func createFavoritesView() {
        router?.navigateToFavoritesView()
    }
}
