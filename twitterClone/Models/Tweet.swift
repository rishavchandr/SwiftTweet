//
//  Tweet.swift
//  twitterClone
//
//  Created by Rishav chandra on 24/07/25.
//

import Foundation


struct Tweet: Codable , Identifiable {
    var  id = UUID().uuidString
    let author: TweetUser
    let authorId: String
    let tweetContent: String
    var likesCount: Int
    var likers: [String]
    let isReply: Bool
    let parentRefrence: String?
}
