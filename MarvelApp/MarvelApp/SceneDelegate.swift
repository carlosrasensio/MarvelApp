//
//  SceneDelegate.swift
//  MarvelApp
//
//  Created by crodrigueza on 16/2/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  var coreDataManager: CoreDataManagerProtocol?
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    
    // MARK: App main view configuration
    window = UIWindow(frame: UIScreen.main.bounds)
    let viewController = CharacterListRouter().viewController
    let navigationController = UINavigationController(rootViewController: viewController)
    configureNavigationBar(navigationController)
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()
    window?.windowScene = windowScene
  }
  
  func sceneDidEnterBackground(_ scene: UIScene) {
    coreDataManager = CoreDataManager()
    guard let coreDataManager else { return }
    coreDataManager.saveContext()
  }
}

// MARK: - Navigation bar UI

extension SceneDelegate {
  func configureNavigationBar(_ navigationController: UINavigationController) {
    let appearance = UINavigationBarAppearance()
    appearance.backgroundColor = .red
    appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
    appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
    navigationController.navigationBar.tintColor = .black
    navigationController.navigationBar.standardAppearance = appearance
    navigationController.navigationBar.compactAppearance = appearance
    navigationController.navigationBar.scrollEdgeAppearance = appearance
  }
}
