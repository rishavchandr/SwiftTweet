//
//  cloudinaryManager.swift
//  twitterClone
//
//  Created by Rishav chandra on 21/07/25.
//

import Foundation
import UIKit
import Cloudinary
import Combine


class CloudinaryManager {
    static let shared = CloudinaryManager()
    
    private let cloudinary: CLDCloudinary
    
    private init() {
        let config = CLDConfiguration(
            cloudName:  SecretsManager.shared.cloudName,
            secure: true
        )
        cloudinary = CLDCloudinary(configuration: config)
    }
    
    func uplaodImage(upload  image: UIImage) -> AnyPublisher<String,Error> {
        return Future<String, Error> { promise in
            guard let imageData = image.jpegData(compressionQuality: 0.5) else {
                promise(.failure(NSError(domain: "Upload", code: -1, userInfo: [NSLocalizedDescriptionKey: "Image conversion failed."])))
                return}
            
            let params = CLDUploadRequestParams()
                .setUploadPreset(SecretsManager.shared.uploadPreset)
                .setFolder(SecretsManager.shared.uploadFolder)
            
            
            self.cloudinary.createUploader().upload(data: imageData, uploadPreset: SecretsManager.shared.uploadPreset , params: params, completionHandler:  {  result , error in
                
                if let error = error {
                    promise(.failure(error))
                    return
                }
                
                if let url = result?.secureUrl {
                    promise(.success(url))
                }else {
                    promise(.failure(NSError(domain: "Upload", code: -2, userInfo: [NSLocalizedDescriptionKey: "Could not retrieve secure URL."])))
                }
            })
        }
        .eraseToAnyPublisher()
    }
}



