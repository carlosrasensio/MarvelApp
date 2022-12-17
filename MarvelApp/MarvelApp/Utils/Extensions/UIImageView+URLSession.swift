//
//  UIImageView+URLSession.swift
//  MarvelApp
//
//  Created by crodrigueza on 17/2/22.
//

import UIKit

extension UIImageView {
    typealias Variant = Constants.NetworkManager.Image.Variant

    func getImageFromURL(_ path: String, _ variant: Variant, _ imageExtension: String) {
        if self.image == nil {
            self.image = UIImage(named: Constants.appIcon)
        }
        let urlString = "\(path)/\(variant.rawValue).\(imageExtension)"
        URLSession.shared.dataTask(with: URL(string: urlString)!) { (data, response, error) in
            guard error == nil else { return }
            DispatchQueue.main.async {
                guard let data = data else { return }
                let image = UIImage(data: data)
                self.image = image
            }
        }.resume()
    }
}
