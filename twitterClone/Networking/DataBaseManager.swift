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
        let docRef: DocumentReference
            if let id = tweet.id {
                docRef = db.collection(tweetsPath).document(id)
            } else {
                docRef = db.collection(tweetsPath).document()
            }

            var tweetWithId = tweet
            tweetWithId.id = docRef.documentID
        
        return docRef.setData(from: tweetWithId)
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
    
    func updateLike(for tweetid: String , userid: String ,isLike: Bool) ->AnyPublisher<Bool , Error> {
        
        let tweetRef = db.collection(tweetsPath).document(tweetid)
        
        return Future<Bool,Error> {[weak self] promise in
            self?.db.runTransaction({ transaction , errorPointer -> Any? in
                do{
                    let snapshot = try transaction.getDocument(tweetRef)
                    
                    var likers = snapshot.get("likers") as? [String] ?? []
                    var likesCount = snapshot.get("likesCount") as? Int ?? 0
                    
                    if isLike , !likers.contains(userid) {
                        likers.append(userid)
                        likesCount += 1
                    }else if !isLike , let idx = likers.firstIndex(of: userid){
                        likers.remove(at: idx)
                        likesCount -= 1
                    }
                    
                    transaction.updateData(["likers": likers ,"likesCount": likesCount], forDocument: tweetRef)
                    
                    return true
                    
                }catch {
                    errorPointer?.pointee = error as NSError
                    return false
                }
                
            }, completion: {_ , error in
                error == nil ? promise(.success(true)) : promise(.failure(error!))
            })
            
        }
        .eraseToAnyPublisher()
    }
    
    
    func updateRetweet(for tweetId: String , userid: String ,isRetweet: Bool) -> AnyPublisher<Bool , Error> {
        
        let tweetref = db.collection(tweetsPath).document(tweetId)
        
        return Future<Bool,Error> { [weak self] promise in
            
            self?.db.runTransaction({ transaction , errorPointer ->Any? in
                do {
                    let snapshot = try transaction.getDocument(tweetref)
                    
                   var retweetCount =  snapshot.get("retweetCount") as? Int ?? 0
                   var retweeters = snapshot.get("retweeters") as? [String] ?? []
                    
                   if isRetweet , !retweeters.contains(userid) {
                        retweeters.append(userid)
                        retweetCount += 1
                    }else if !isRetweet , let idx = retweeters.firstIndex(of: userid) {
                        retweeters.remove(at: idx)
                        retweetCount -= 1
                    }
                    
                    transaction.updateData(["retweeters": retweeters ,"retweetCount": retweetCount], forDocument: tweetref)
                    
                    return true
                    
                }catch {
                    errorPointer?.pointee = error as NSError
                    return false
                }
            }, completion: { _, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(true))
                }
            })
        }
        .eraseToAnyPublisher()
    }
    
    func collectionTweet(with Id: String) ->AnyPublisher<Tweet ,Error>{
        db.collection(tweetsPath).document(Id).getDocument()
            .tryMap { snapshot -> Tweet in
                guard let tweet = try? snapshot.data(as: Tweet.self) else {
                    throw NSError(domain: "Firestore", code: 0, userInfo: [NSLocalizedDescriptionKey : "Tweet not fount"])
                }
                return tweet
            }
            .eraseToAnyPublisher()
    }
}

