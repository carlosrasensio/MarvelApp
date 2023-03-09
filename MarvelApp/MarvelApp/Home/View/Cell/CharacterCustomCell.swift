//
//  CharacterCustomCell.swift
//  MarvelApp
//
//  Created by crodrigueza on 16/2/22.
//

import UIKit

final class CharacterCustomCell: UITableViewCell {
  // MARK: Objects
  lazy var containerView = UIView()
  lazy var titleLabel = UILabel()
  lazy var characterImageView = UIImageView()
  
  // MARK: Initializers
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Cell configuration
  override func prepareForReuse() {
    titleLabel.text = nil
    characterImageView.image = nil
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    contentView.backgroundColor = UIColor.black
  }
  
  func setupUI() {
    contentView.backgroundColor = .black
    setupContainerView()
    setupCharacterImageView()
    setupTitleLabel()
  }
}

// MARK: - Private methods

private extension CharacterCustomCell {
  func setupContainerView() {
    containerView.backgroundColor = .black
    containerView.layer.cornerRadius = 6
    containerView.layer.shadowOffset = .zero
    containerView.layer.shadowRadius = 10
    containerView.layer.shadowOpacity = 0.5
    containerView.layer.shadowColor = UIColor.white.cgColor
    containerView.layer.shouldRasterize = true
    containerView.layer.rasterizationScale = UIScreen.main.scale
    containerView.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(containerView)
    NSLayoutConstraint.activate([
      containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
      containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
      containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
      containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
    ])
  }
  
  func setupCharacterImageView() {
    characterImageView.layer.cornerRadius = 10
    characterImageView.clipsToBounds = true
    characterImageView.translatesAutoresizingMaskIntoConstraints = false
    containerView.addSubview(characterImageView)
    NSLayoutConstraint.activate([
      characterImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 2),
      characterImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 2),
      characterImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -2),
      characterImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -2),
    ])
  }
  
  func setupTitleLabel() {
    titleLabel.backgroundColor = .red
    titleLabel.textColor = .black
    titleLabel.font = .boldSystemFont(ofSize: 30)
    titleLabel.adjustsFontSizeToFitWidth = true
    titleLabel.textAlignment = .center
    titleLabel.layer.cornerRadius = titleLabel.frame.size.height/2.0
    titleLabel.layer.masksToBounds = true
    titleLabel.backgroundColor = .red
    titleLabel.alpha = 0.8
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    containerView.addSubview(titleLabel)
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 6),
      titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 6),
      titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -6)
    ])
  }
}
