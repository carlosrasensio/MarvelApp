//
//  CharacterDetailViewModel.swift
//  MarvelApp
//
//  Created by crodrigueza on 16/2/22.
//

import Foundation
import RxSwift

protocol CharacterDetailViewModelProtocol {
    var view: CharacterDetailViewController? { get }
    var router: CharacterDetailRouter? { get }
    func bind(view: CharacterDetailViewController, router: CharacterDetailRouter)
    func saveFavorite(_ favorite: Character)
}

final class CharacterDetailViewModel: CharacterDetailViewModelProtocol {
    // MARK: - Variables
    weak var view: CharacterDetailViewController?
    var router: CharacterDetailRouter?
    private var dataManager = DataManager()

    // MARK: - Connecting view and router
    func bind(view: CharacterDetailViewController, router: CharacterDetailRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }

    func saveFavorite(_ favorite: Character) {
        dataManager.saveFavorite(favorite)
    }
}
