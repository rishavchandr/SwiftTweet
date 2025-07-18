//
//  TwitterUser.swift
//  twitterClone
//
//  Created by Rishav chandra on 18/07/25.
//

import Foundation
import FirebaseAuth


struct TweetUser: Codable {
    let id: String
    var displayName: String = ""
    var username: String = ""
    var followersCount: Double = 0
    var followingCount: Double = 0
    var createdON: Date = Date()
    var bio: String = ""
    var avatarPath: String = ""
    var isUserOnboard: Bool = false
    
    init(form user: User){
        self.id = user.uid
    }
}
