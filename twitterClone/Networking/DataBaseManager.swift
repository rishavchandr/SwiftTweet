//
//  DataBaseManager.swift
//  twitterClone
//
//  Created by Rishav chandra on 18/07/25.
//

import Foundation
import Firebase
import FirebaseFirestoreCombineSwift
import Combine
import FirebaseFirestore
import FirebaseAuth


class DataBaseManager {
    
    static let shared = DataBaseManager()
    
    let db = Firestore.firestore()
    let usersPath: String = "users"
    let tweetsPath: String = "tweets"
    let followingPath: String = "followings"
    
    func collectionUser(add user: User) -> AnyPublisher<Bool, Error> {
        let twitterUser = TweetUser(form: user)
        return db.collection(usersPath).document(twitterUser.id).setData(from: twitterUser)
            .map{_ in return true}
            .eraseToAnyPublisher()
    }
    
    
    func collectionUser(retrieve id: String) -> AnyPublisher<TweetUser,Error> {
        db.collection(usersPath).document(id).getDocument()
            .tryMap {try $0.data(as: TweetUser.self)}
            .eraseToAnyPublisher()
        
    }
    
    func collectionUsers(updateFields: [String: Any] , for id: String) -> AnyPublisher<Bool,Error> {
        db.collection(usersPath).document(id).updateData(updateFields)
            .map{_ in true}
            .eraseToAnyPublisher()
    }
    
    func collectionTweets(dispatch tweet: Tweet) -> AnyPublisher<Bool,Error> {
        db.collection(tweetsPath).document(tweet.id).setData(from: tweet)
            .map{_ in return true}
            .eraseToAnyPublisher()
    }
    
    func collectionUsers(search query: String) -> AnyPublisher<[TweetUser] , Error> {
        db.collection(usersPath).whereField("username", isEqualTo: query)
            .getDocuments()
            .map(\.documents)
            .tryMap { Snapshort in
                try Snapshort.map({
                    try $0.data(as: TweetUser.self)
                })
            }
            .eraseToAnyPublisher()
    }
    
    func collectionTweets(retrieve forUserId: String) -> AnyPublisher<[Tweet] , Error> {
        db.collection(tweetsPath).whereField("authorId", isEqualTo: forUserId)
            .getDocuments()
            .tryMap(\.documents)
            .tryMap { Snapshort in
                try Snapshort.map({
                    try $0.data(as: Tweet.self)
                })
            }
            .eraseToAnyPublisher()
    }
    
    
    func collectionFollowings(isFollower: String , following: String) -> AnyPublisher<Bool , Error> {
        db.collection(followingPath)
            .whereField("follower", isEqualTo: isFollower)
            .whereField("following", isEqualTo: following)
            .getDocuments()
            .map(\.count)
            .map {
                $0 != 0
            }
            .eraseToAnyPublisher()
    }
    
    func collectionFollowings(follower: String , following: String) -> AnyPublisher<Bool , Error> {
        db.collection(followingPath).document().setData([
            "follower" : follower,
            "following": following
        ])
        .map{true}
        .eraseToAnyPublisher()
    }
    
    func collectionFollowings(delete follower: String , following: String) -> AnyPublisher<Bool , Error> {
        db.collection(followingPath)
            .whereField("follower", isEqualTo: follower)
            .whereField("following", isEqualTo: following)
            .getDocuments()
            .map(\.documents.first)
            .map { query in
                query?.reference.delete(completion: nil)
                return true
            }
            .eraseToAnyPublisher()
            
    }
}
