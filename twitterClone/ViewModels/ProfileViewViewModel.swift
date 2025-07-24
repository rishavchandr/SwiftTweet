//
//  ProfileViewViewModel.swift
//  twitterClone
//
//  Created by Rishav chandra on 21/07/25.
//

import Foundation
import Combine
import FirebaseAuth

final class ProfileViewViewModel {
    
    @Published var user: TweetUser?
    @Published var error: String?
    
    private var subscriptions: Set<AnyCancellable> = []
    
    
    func retrieveData() {
        guard let id = Auth.auth().currentUser?.uid else {return}
        DataBaseManager.shared.collectionUser(retrieve: id)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] user in
                self?.user = user
            }
            .store(in: &subscriptions)

        
    }
    
    func dateFormatter(with date: Date)->String{
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MMM YYYY"
        return dateFormat.string(from: date)
    }
    
    
}
