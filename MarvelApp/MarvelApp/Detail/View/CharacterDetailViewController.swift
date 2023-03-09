//
//  CharacterDetailViewController.swift
//  MarvelApp
//
//  Created by crodrigueza on 16/2/22.
//

import UIKit

protocol CharacterDetailViewControllerProtocol {
  func setupInfo()
}

final class CharacterDetailViewController: UIViewController {
  // MARK: Objects
  private lazy var characterImageView = UIImageView()
  private lazy var titleLabel = UILabel()
  private lazy var descriptionLabel = UILabel()
  private lazy var favoriteButton = UIButton()
  
  // MARK: Variables
  private var router: CharacterDetailRouterProtocol
  private var viewModel: CharacterDetailViewModelProtocol
  private var coreDataManager: CoreDataManagerProtocol
  var character: Character?
  var isHiddenFavoriteButton: Bool?
  
  // MARK: Initializers
  init(router: CharacterDetailRouterProtocol, viewModel: CharacterDetailViewModelProtocol, coreDataManager: CoreDataManagerProtocol) {
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
    setupNavigationBar()
    setupUI()
    setupInfo()
    viewModel.bind(view: self, router: router, coreDataManager: coreDataManager)
  }
}

// MARK: - CharacterDetailViewControllerProtocol
extension CharacterDetailViewController: CharacterDetailViewControllerProtocol {
  func setupInfo() {
    guard let character = character else { return }
    characterImageView.getImageFromURL(character.thumbnail.path, .portrait_incredible, character.thumbnail.imageExtension)
    titleLabel.text = character.name
    if character.description == "" {
      descriptionLabel.text = "*No info*"
    } else {
      descriptionLabel.text = character.description
    }
    favoriteButton.setTitle("Favorite", for: .normal)
  }
}

// MARK: - Private methods
private extension CharacterDetailViewController {
  func setupNavigationBar() {
    self.navigationItem.title = "Detail"
  }
  
  func setupUI() {
    DispatchQueue.main.async {
      self.view.backgroundColor = .black
      self.setupCharacterImageView()
      self.setupTitleLabel()
      self.setupDescriptionLabel()
      self.setupFavoriteButton()
    }
  }
  
  func setupCharacterImageView() {
    view.addSubview(characterImageView)
    characterImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      characterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
      characterImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
      characterImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80),
      characterImageView.heightAnchor.constraint(equalToConstant: 320)
    ])
  }
  
  func setupTitleLabel() {
    view.addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 36),
      titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
      titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80),
      titleLabel.heightAnchor.constraint(equalToConstant: 30)
    ])
    
    titleLabel.font = .boldSystemFont(ofSize: 24)
    titleLabel.textAlignment = .center
    titleLabel.textColor = .white
  }

  func setupDescriptionLabel() {
    view.addSubview(descriptionLabel)

    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
      descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
      descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80)
    ])

    descriptionLabel.textAlignment = .justified
    descriptionLabel.numberOfLines = 0
    descriptionLabel.textColor = .white
  }

  func setupFavoriteButton() {
    view.addSubview(favoriteButton)

    favoriteButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      favoriteButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 36),
      favoriteButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -36),
      favoriteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      favoriteButton.heightAnchor.constraint(equalToConstant: 40),
      favoriteButton.widthAnchor.constraint(equalToConstant: 120)
    ])

    favoriteButton.isHidden = isHiddenFavoriteButton ?? false
    favoriteButton.backgroundColor = .red
    favoriteButton.setTitleColor(.black, for: .normal)
    favoriteButton.layer.cornerRadius = 20
    favoriteButton.addTarget(self, action: #selector(didPressFavoriteButton), for: .touchUpInside)
  }
  
  func saveFavorite() {
    guard let character = character else { return }
    viewModel.saveFavorite(character)
  }
}

// MARK: - Actions
@objc extension CharacterDetailViewController {
  func didPressFavoriteButton() {
    saveFavorite()
    guard let character = character else { return }
    showAlert(title: "Congrats!", message: "The character \(character.name) has been saved successfully.")
  }
}
