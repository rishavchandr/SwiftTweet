//
//  ProfileViewViewModel.swift
//  twitterClone
//
//  Created by Rishav chandra on 21/07/25.
//

import Foundation
import Combine
import FirebaseAuth


enum ProfileFollwingState {
    case userIsFollwed
    case userIsUnfollwed
    case personal
}

final class ProfileViewViewModel {
    
    @Published var user: TweetUser
    @Published var error: String?
    @Published var tweets: [Tweet] = []
    @Published var currentState: ProfileFollwingState = .personal
    
    private var subscriptions: Set<AnyCancellable> = []
    
    init(user: TweetUser){
        self.user = user
        checkIfFollwed()
    }
    
    private func checkIfFollwed() {
        guard let personalUserId = Auth.auth().currentUser?.uid ,
        personalUserId != user.id
        else {
            currentState = .personal
            return
        }
        DataBaseManager.shared.collectionFollowings(isFollower: personalUserId, following: user.id)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { isFollowed in
                self.currentState = isFollowed ? .userIsFollwed : .userIsUnfollwed
            }
            .store(in: &subscriptions)
        
    }
        
    func fetchUserTweets() {
        DataBaseManager.shared.collectionTweets(retrieve: user.id)
              .sink { completion in
                  if case .failure(let error) = completion {
                      print(error.localizedDescription)
                  }
              } receiveValue: { [weak self] tweets in
                  self?.tweets = tweets
              }
              .store(in: &subscriptions)

    }
    
    func isUnfollow(){
        guard let personalUserId = Auth.auth().currentUser?.uid else { return }
        DataBaseManager.shared.collectionFollowings(delete: personalUserId, following: user.id)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] _ in
                self?.currentState = .userIsUnfollwed
            }
            .store(in: &subscriptions)

    }
    
    func isFollow(){
        guard let personalUserId = Auth.auth().currentUser?.uid else { return }
        DataBaseManager.shared.collectionFollowings(follower: personalUserId, following: user.id)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] _ in
                self?.currentState = .userIsFollwed
            }
            .store(in: &subscriptions)

    }
    
    func dateFormatter(with date: Date)->String{
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MMM YYYY"
        return dateFormat.string(from: date)
    }
    
    
}
