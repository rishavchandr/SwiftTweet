//
//  CacheImageUtitlity.swift
//  twitterClone
//
//  Created by Rishav chandra on 21/07/25.
//

import Foundation
import UIKit

private let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func setImage(from urlString: String) {
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let _ = error { return }
            guard let data = data, let downloadedImage = UIImage(data: data) else { return }

            imageCache.setObject(downloadedImage, forKey: urlString as NSString)

            DispatchQueue.main.async {
                self?.image = downloadedImage
            }
        }.resume()
    }
}

