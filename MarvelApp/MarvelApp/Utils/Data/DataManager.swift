//
//  DataManager.swift
//  MarvelApp
//
//  Created by crodrigueza on 16/2/22.
//

import Foundation
import CoreData

protocol DataManagerProtocol {
  func saveFavorite(_ favorite: Character)
  func deleteFavorite(_ name: String)
  func getFavorites() -> [Character]
}

final class DataManager {
  let coreDataModel = "MarvelApp"
  let characterEntity = "MarvelCharacter"
  
  
  
  // MARK: Core Data stack
  lazy var persistentContainer: NSPersistentContainer = {
    let persistentContainer = NSPersistentContainer(name: coreDataModel)
    persistentContainer.loadPersistentStores { _, error in
      if let error = error as NSError? {
        fatalError("\n❌ Unresolved error \(error), \(error.userInfo)")
      }
    }
    
    return persistentContainer
  }()
  
  var context: NSManagedObjectContext {
    persistentContainer.viewContext
  }
  
  // MARK: Core Data Saving support
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
}

// MARK: - DataManagerProtocol

extension DataManager: DataManagerProtocol {
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
    let fetchRequest = NSFetchRequest<MarvelCharacter>(entityName: characterEntity)
    fetchRequest.predicate = NSPredicate(format:"name = %@", name)
    do {
      let favorites = try context.fetch(fetchRequest)
      if favorites.count > 0 {
        context.delete(favorites[0])
      }
      try context.save()
    } catch {
      fatalError("\n❌ ERROR: failed to delete favorite --> \(error.localizedDescription)")
    }
  }
  
  func getFavorites() -> [Character] {
    do {
      let fetchRequest = NSFetchRequest<MarvelCharacter>(entityName: characterEntity)
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
