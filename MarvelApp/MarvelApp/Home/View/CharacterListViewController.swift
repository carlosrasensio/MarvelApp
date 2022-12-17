//
//  CharacterListViewController.swift
//  MarvelApp
//
//  Created by crodrigueza on 16/2/22.
//

import UIKit
import RxSwift
import RxCocoa

protocol CharacterListViewControllerProtocol {
    func configureTableView()
    func getCharacters(offset: Int)
}

final class CharacterListViewController: UIViewController, CharacterListViewControllerProtocol {
    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Variables
    private var router = CharacterListRouter()
    private var viewModel = CharacterListViewModel()
    private var disposeBag = DisposeBag()
    private let pageLimit = Constants.NetworkManager.limit
    private var filteredCharacters = [Character]()
    private var characters = [Character]() {
        didSet {
                self.reloadTableView()
        }
    }
    lazy var searchController: UISearchController = ({
        createSearchBarController()
    })()

    enum TableSection: Int {
        case charactersList
        case loader
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureSearchBarController()
        configureTableView()
        viewModel.bind(view: self, router: router)
        getCharacters()
    }

    // MARK: - NavigationItem configuration
    private func configureNavigationBar() {
        self.navigationItem.title = "Home"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favs", style: .plain, target: self, action: #selector(showFavorites))
        navigationItem.rightBarButtonItem?.tintColor = .black
    }

    // MARK: - Table view configuration
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: Constants.CustomCells.characterCellId, bundle: nil), forCellReuseIdentifier: Constants.CustomCells.characterCellId)
    }

    private func reloadTableView() {
        DispatchQueue.main.async {
            self.setActivityIndicator(false)
            self.tableView.reloadData()
        }
    }

    private func hideBottomLoader() {
        DispatchQueue.main.async {
            let lastListIndexPath = IndexPath(row: self.characters.count - 1, section: TableSection.charactersList.rawValue)
            self.tableView.scrollToRow(at: lastListIndexPath, at: .bottom, animated: true)
        }
    }

    // MARK: - Activity indicator configuraion
    private func setActivityIndicator(_ show: Bool) {
        if show {
            self.activityIndicator.startAnimating()
        } else {
            self.activityIndicator.stopAnimating()
        }
        self.activityIndicator.isHidden = !show
    }
}

// MARK: - Get data from ViewModel with RxSwift
extension CharacterListViewController {
    func getCharacters(offset: Int = 0) {
        setActivityIndicator(true)
        return viewModel.getCharacters(offset: offset)
            .subscribe(on: MainScheduler.instance)
            .observe(on: MainScheduler.instance)
            .subscribe { characters in
                for character in characters {
                    self.characters.append(character)
                }
                self.reloadTableView()
            } onError: { error in
                print("\n[X] Error: \(error.localizedDescription)\n")
                self.showAlert(title: "ERROR", message: error.localizedDescription)
            } onCompleted: {}
            .disposed(by: disposeBag)
    }
}

// MARK: - Navigation bar right item action
private extension CharacterListViewController {
    @objc func showFavorites() {
        viewModel.createFavoritesView()
    }
}

// MARK: - SearchController functions
extension CharacterListViewController: UISearchControllerDelegate {
    private func createSearchBarController() -> UISearchController {
        let controller = UISearchController(searchResultsController: nil)
        controller.hidesNavigationBarDuringPresentation = true
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.sizeToFit()
        controller.searchBar.barStyle = .default
        controller.searchBar.backgroundColor = .red
        controller.searchBar.placeholder = "Search your MARVEL character!"
        let cancelButtonAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red]
         UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes, for: .normal)

        return controller
    }

    private func configureSearchBarController() {
        let searchBar = searchController.searchBar
        searchController.delegate = self
        tableView.tableHeaderView = searchBar
        tableView.contentOffset = CGPoint(x: 0, y: searchBar.frame.size.height)
        searchBar.rx.text
            .orEmpty
            .distinctUntilChanged()
            .subscribe { result in
                self.filteredCharacters = self.characters.filter({ character in
                    self.reloadTableView()
                    return character.name.contains(result)
                })
            } onError: { error in
                print("\n[X] Error: \(error.localizedDescription)\n")
                self.showAlert(title: "ERROR", message: error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
        reloadTableView()
    }
}

// MARK: - TableView functions
extension CharacterListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let listSection = TableSection(rawValue: section) else { return 0 }
        switch listSection {
        case .charactersList:
            if searchController.isActive && searchController.searchBar.text != "" {
                return filteredCharacters.count
            } else {
                return characters.count
            }
        case .loader:
            if searchController.isActive && searchController.searchBar.text != "" {
                return filteredCharacters.count >= pageLimit ? 1 : 0
            } else {
                return characters.count >= pageLimit ? 1 : 0
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = TableSection(rawValue: indexPath.section) else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCells.characterCellId) as! CharacterCustomCell
        switch section {
        case .charactersList:
            if searchController.isActive && searchController.searchBar.text != "" {
                cell.titleLabel.text = "\(indexPath.row + 1). " + filteredCharacters[indexPath.row].name
                let imagePath = filteredCharacters[indexPath.row].thumbnail.path
                let imageExtension = filteredCharacters[indexPath.row].thumbnail.imageExtension
                cell.characterImageView.getImageFromURL(imagePath, .landscape_amazing, imageExtension)
            } else {
                cell.titleLabel.text = "\(indexPath.row + 1). " + characters[indexPath.row].name
                let imagePath = characters[indexPath.row].thumbnail.path
                let imageExtension = characters[indexPath.row].thumbnail.imageExtension
                cell.characterImageView.getImageFromURL(imagePath, .landscape_amazing, imageExtension)
            }
        case .loader:
            cell.titleLabel.text = "Loading..."
        }

        return cell
    }
}

extension CharacterListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchController.isActive && searchController.searchBar.text != "" {
            viewModel.createCharacterDetailView(filteredCharacters[indexPath.row])
        } else {
            viewModel.createCharacterDetailView(characters[indexPath.row])
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let section = TableSection(rawValue: indexPath.section) else { return }
        guard !characters.isEmpty else { return }
        if section == .loader {
            getCharacters(offset: characters.count)
            hideBottomLoader()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
