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
    
    private var subscription: Set<AnyCancellable> = []
    
    
    func retrieveUser() {
        guard let id = Auth.auth().currentUser?.uid else {return}
        DataBaseManager.shared.collectionUser(retrieve: id)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                self?.user = user
            }
            .store(in: &subscription)

    }
    
}
