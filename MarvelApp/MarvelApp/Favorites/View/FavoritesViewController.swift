//
//  FavoritesViewController.swift
//  MarvelApp
//
//  Created by crodrigueza on 22/2/22.
//

import UIKit

protocol FavoritesViewControllerProtocol {
  func setupUI()
  func getFavorites()
  func deleteFavorite(_ name: String)
}

final class FavoritesViewController: UIViewController {
  // MARK: Objects
  private lazy var tableView = UITableView()
  private lazy var activityIndicator = UIActivityIndicatorView()
  
  // MARK: Variables
  private var router: FavoritesRouterProtocol
  private var viewModel: FavoritesViewModelProtocol
  private var coreDataManager: CoreDataManagerProtocol
  var favorites = [Character]()
  
  // MARK: Initializers
  init(router: FavoritesRouterProtocol, viewModel: FavoritesViewModelProtocol, coreDataManager: CoreDataManagerProtocol) {
    self.router = router
    self.viewModel = viewModel
    self.coreDataManager = coreDataManager
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    viewModel.bind(view: self, router: router, coreDataManager: coreDataManager)
    getFavorites()
  }
}

// MARK: - FavoritesViewControllerProtocol

extension FavoritesViewController: FavoritesViewControllerProtocol {
  func setupUI() {
    setupNavigationItem()
    setupActivityIndicator()
    setupTableView()
  }
  
  func getFavorites() {
    self.favorites = viewModel.getCoreDataFavorites()
    self.reloadTableView()
  }
  
  func deleteFavorite(_ name: String) {
    viewModel.deleteFavorite(name)
  }
}

// MARK: - Private methods

private extension FavoritesViewController {
  func setupNavigationItem() {
    navigationController?.navigationBar.barTintColor = UIColor.red
    self.navigationItem.title = "Favorites"
    navigationItem.rightBarButtonItem?.tintColor = .black
  }
  
  func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.rowHeight = UITableView.automaticDimension
    tableView.backgroundColor = .black
    tableView.register(CharacterCustomCell.self, forCellReuseIdentifier: Constants.CustomCells.characterCellId)
    tableView.accessibilityIdentifier = "favoritesTableView"
    
    view.addSubview(tableView)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
  }
  
  func setupActivityIndicator() {
    view.addSubview(activityIndicator)
    activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    
    activityIndicator.color = .red
  }
  
  func setActivityIndicator(_ show: Bool) {
    activityIndicator.isHidden = !show
    if show {
      activityIndicator.startAnimating()
    } else {
      activityIndicator.stopAnimating()
    }
  }
  
  func reloadTableView() {
    DispatchQueue.main.async {
      self.setActivityIndicator(false)
      self.tableView.reloadData()
    }
  }
}

// MARK: - UITableViewDataSource

extension FavoritesViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return favorites.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCells.characterCellId, for: indexPath) as! CharacterCustomCell
    cell.titleLabel.text = "\(indexPath.row + 1). " + favorites[indexPath.row].name
    let imagePath = favorites[indexPath.row].thumbnail.path
    let imageExtension = favorites[indexPath.row].thumbnail.imageExtension
    cell.characterImageView.getImageFromURL(imagePath, .landscape_amazing, imageExtension)
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    200
  }
}

// MARK: - UITableViewDelegate

extension FavoritesViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel.createCharacterDetailView(favorites[indexPath.row])
  }
  
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let action = UIContextualAction(style: .destructive, title: "Delete") { action, _, _  in
      self.deleteFavorite(self.favorites[indexPath.row].name)
      self.favorites.remove(at: indexPath.row)
      self.tableView.deleteRows(at: [indexPath], with: .fade)
      self.getFavorites()
    }
    
    return UISwipeActionsConfiguration(actions: [action])
  }
}
