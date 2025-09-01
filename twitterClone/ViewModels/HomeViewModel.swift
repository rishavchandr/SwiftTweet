//
//  HomeViewModel.swift
//  twitterClone
//
//  Created by Rishav chandra on 18/07/25.
//

import Foundation
import Combine
import FirebaseAuth

final class HomeViewModel : ObservableObject {
    
    
    @Published var user: TweetUser?
    @Published var error: String?
    @Published var tweets: [Tweet] = []
    @Published var tweet: Tweet?
    
    private var subscription: Set<AnyCancellable> = []
    
    
    func retrieveUser() {
        guard let id = Auth.auth().currentUser?.uid else {return}
        DataBaseManager.shared.collectionUser(retrieve: id)
            .handleEvents(receiveOutput: { [weak self] user in
                self?.user = user
                self?.fetchTweets()
            })
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                self?.user = user
            }
            .store(in: &subscription)

    }
    
    
    func fetchTweets() {
        guard let userId = user?.id else {return}
        DataBaseManager.shared.collectionTweets(retrieve: userId)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] retrievetweets in
                self?.tweets = retrievetweets
            }
            .store(in: &subscription)

    }
    
    
    func likeTweet(for tweet: Tweet) {
        guard let userId = user?.id , let tweetId = tweet.id else {return}
        let isLike = tweet.likers.contains(userId)
        DataBaseManager.shared.updateLike(for: tweetId, userid: userId, isLike: !isLike)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] _ in
                self?.fetchTweets()
            }
            .store(in: &subscription)
    }
    
    func retweetTweet(for tweet: Tweet) {
        guard let userId = user?.id , let tweetId = tweet.id else {return}
        let isRetweet = tweet.retweeters.contains(userId)
        DataBaseManager.shared.updateRetweet(for: tweetId, userid: userId, isRetweet: !isRetweet)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] _ in
                self?.fetchTweets()
            }
            .store(in: &subscription)
    }
    
    func  fetchTweet(with tweetId: String) {
        DataBaseManager.shared.collectionTweet(with: tweetId)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] tweet in
                self?.tweet = tweet
            }
            .store(in: &subscription)

    }
}
