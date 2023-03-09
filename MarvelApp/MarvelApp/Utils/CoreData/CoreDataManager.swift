//
//  CoreDataManager.swift
//  MarvelApp
//
//  Created by crodrigueza on 16/2/22.
//

import Foundation
import CoreData

protocol CoreDataManagerProtocol {
  func saveContext()
  func saveFavorite(_ favorite: Character)
  func deleteFavorite(_ name: String)
  func getCoreDataFavorites() -> [Character]
}

final class CoreDataManager {
  // MARK: Core Data stack
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: Constants.CoreDataManager.coreDataModel)
    container.loadPersistentStores(completionHandler: { _, error in
      if let error = error as NSError? {
        fatalError("\n❌ Unresolved error \(error), \(error.userInfo)")
      }
    })
    
    return container
  }()
  
  var context: NSManagedObjectContext {
    persistentContainer.viewContext
  }
}

// MARK: - CoreDataManagerProtocol

extension CoreDataManager: CoreDataManagerProtocol {
  func saveContext() {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        let nserror = error as NSError
        fatalError("\n❌ Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
  
  func saveFavorite(_ favorite: Character) {
    let marvelCharacter = MarvelCharacter(context: context)
    marvelCharacter.setValuesForKeys(["name": favorite.name, "desc": favorite.description, "thumbnailPath": favorite.thumbnail.path, "thumbnailExtension": favorite.thumbnail.imageExtension])
    do {
      try context.save()
    } catch {
      fatalError("\n❌ ERROR: failed to save favorite --> \(error.localizedDescription)")
    }
  }
  
  func deleteFavorite(_ name: String) {
    let fetchRequest = NSFetchRequest<MarvelCharacter>(entityName: Constants.CoreDataManager.characterEntity)
    fetchRequest.predicate = NSPredicate(format:"name = %@", name)
    do {
      let favorites = try context.fetch(fetchRequest)
      if !favorites.isEmpty {
        context.delete(favorites[0])
      }
      try context.save()
    } catch {
      fatalError("\n❌ ERROR: failed to delete favorite --> \(error.localizedDescription)")
    }
  }
  
  func getCoreDataFavorites() -> [Character] {
    do {
      let fetchRequest = NSFetchRequest<MarvelCharacter>(entityName: Constants.CoreDataManager.characterEntity)
      let marvelCharacters = try context.fetch(fetchRequest)
      var favorites = [Character]()
      for marvelCharacter in marvelCharacters {
        let thumbnail = Thumbnail(path: marvelCharacter.thumbnailPath!, imageExtension: marvelCharacter.thumbnailExtension!)
        let favorite = Character(name: marvelCharacter.name!, description: marvelCharacter.desc!, thumbnail: thumbnail)
        favorites.append(favorite)
      }
      
      return favorites
    } catch {
      fatalError("\n❌ ERROR: failed to get favorites --> \(error.localizedDescription)")
    }
  }
}
