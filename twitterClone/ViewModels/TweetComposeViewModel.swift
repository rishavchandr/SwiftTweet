//
//  TweetComposeViewModel.swift
//  twitterClone
//
//  Created by Rishav chandra on 24/07/25.
//

import Foundation
import Combine
import FirebaseAuth

final class TweetComposeViewModel: ObservableObject {
    
    
    private var subscriptions: Set<AnyCancellable> = []
    
    @Published var user: TweetUser?
    @Published var error: String?
    var tweetContent: String = ""
    @Published var isVaildTweet: Bool = false
    @Published var shouldDismissCompose: Bool = false
    
    
    
    func getUser() {
        guard let id = Auth.auth().currentUser?.uid else {return}
        DataBaseManager.shared.collectionUser(retrieve: id)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [unowned self] user in
                self.user = user
            }
            .store(in: &subscriptions)

    }
    
    func validateTweet() {
        isVaildTweet = !tweetContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func dispatchTweet(){
        guard let user = user else { return }
        let tweet = Tweet(author: user, authorId: user.id, tweetContent: tweetContent, likesCount: 0, likers: [], isReply: false , parentRefrence: nil)
        
        DataBaseManager.shared.collectionTweets(dispatch: tweet)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] state in
                self?.shouldDismissCompose = state
            }
            .store(in: &subscriptions)
    }
}
