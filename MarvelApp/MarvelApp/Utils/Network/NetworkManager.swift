//
//  NetworkManager.swift
//  MarvelApp
//
//  Created by crodrigueza on 16/2/22.
//

import Foundation
import RxSwift

protocol NetworkManagerProtocol {
  func getCharacters(offset: Int) -> Observable<[Character]>
}

final class NetworkManager {
  // MARK: Variable
  private var urlHandler: URLHandler
  
  // MARK: Initializer
  init(urlHandler: URLHandler) {
    self.urlHandler = urlHandler
  }
}

// MARK: - NetworkManagerProtocol

extension NetworkManager: NetworkManagerProtocol {
  func getCharacters(offset: Int) -> Observable<[Character]>  {
    return Observable.create { observer -> Disposable in
      self.urlHandler = URLHandler()
      let url = self.urlHandler.getCharactersURL(offset: offset)
      let session = URLSession.shared
      let task = session.dataTask(with: url) { (data, response, error) in
        guard let data = data, error == nil, let response = response as? HTTPURLResponse else { return }
        if response.statusCode == 200 {
          do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(CharacterDataWrapper.self, from: data)
            if response.data.offset + response.data.responseCount <= response.data.total {
              observer.onNext(response.data.results)
            }
          } catch let error {
            observer.onError(error)
            print("\n❌ Error: \(error.localizedDescription)\n")
          }
        } else {
          print("\n❌ Error: \(response.statusCode)\n")
        }
        observer.onCompleted()
      }
      task.resume()
      
      return Disposables.create {
        session.finishTasksAndInvalidate()
      }
    }
  }
}
