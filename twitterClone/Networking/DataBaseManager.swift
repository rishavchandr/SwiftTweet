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
}
