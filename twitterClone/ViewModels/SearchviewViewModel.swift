//
//  SearchviewViewModel.swift
//  twitterClone
//
//  Created by Rishav chandra on 31/07/25.
//

import Foundation
import Combine

class SearchviewViewModel {
    
    var subscriptions: Set<AnyCancellable> = []
    
    func search(with query: String , _ completion: @escaping([TweetUser]) -> Void){
        DataBaseManager.shared.collectionUsers(search: query)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { users in
                completion(users)
            }
            .store(in: &subscriptions)

    }
}
