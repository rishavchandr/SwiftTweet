//
//  SecretsManager.swift
//  twitterClone
//
//  Created by Rishav chandra on 21/07/25.
//

import Foundation


class SecretsManager {
    static let shared = SecretsManager()
    
    private var secrets: [String: Any] = [:]
    
    private init() {
        if let url = Bundle.main.url(forResource: "sceret", withExtension: "plist"),
           let data = try? Data(contentsOf: url),
           let plist = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any] {
            secrets = plist
        } else {
            print("Failed to load Secrets.plist")
        }
    }
    
    func get(_ key: String) -> String? {
        return secrets[key] as? String
    }
    
    var cloudName: String {
        return get("CLOUD_NAME") ?? ""
    }
    
    var uploadPreset: String {
        return get("UPLOAD_PRESET") ?? ""
    }
    
    var uploadFolder: String {
        return get("UPLOAD_FOLDER") ?? ""
    }
}
