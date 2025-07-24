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
}
