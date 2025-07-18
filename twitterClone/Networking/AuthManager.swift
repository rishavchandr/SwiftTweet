//
//  AuthManager.swift
//  twitterClone
//
//  Created by Rishav chandra on 17/07/25.
//

import Foundation
import Combine
import Firebase
import FirebaseAuth
import FirebaseAuthCombineSwift

class AuthManager {
    static let shared = AuthManager()
    
    func registerUser(with email: String , password: String) -> AnyPublisher<User, Error> {
       return  Auth.auth().createUser(withEmail: email, password: password)
                 .map(\.user)
                 .eraseToAnyPublisher()
    }
    
    func loginUser(with email: String , password: String) -> AnyPublisher<User , Error> {
        return Auth.auth().signIn(withEmail: email, password: password)
            .map(\.user)
            .eraseToAnyPublisher()
    }
}
