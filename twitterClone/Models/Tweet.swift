//
//  Tweet.swift
//  twitterClone
//
//  Created by Rishav chandra on 24/07/25.
//

import Foundation
import FirebaseFirestore


struct Tweet: Codable , Identifiable {
    @DocumentID var id: String?
    let author: TweetUser
    let authorId: String
    let tweetContent: String
    var likesCount: Int
    var likers: [String]
    var retweeters: [String]
    var retweetCount: Int
    let isReply: Bool
    let parentRefrence: String?
}
