//
//  ProfileDataFormViewModel.swift
//  twitterClone
//
//  Created by Rishav chandra on 18/07/25.
//

import Foundation
import UIKit
import Combine
import Firebase
import FirebaseAuth


final class ProfileDataFormViewModel: ObservableObject {
    
    @Published var displayName: String?
    @Published var username: String?
    @Published var bio: String?
    @Published var avatarPath: String?
    @Published var imageData: UIImage?
    @Published var isFormVaild: Bool = false
    @Published var error: String = ""
    @Published var isOnboardingDone: Bool = false
    
    
    private var subscription: Set<AnyCancellable> = []
    
    
    func validateProfileDataForm() {
        guard let displayName = displayName,
              displayName.count > 2,
              let username = username,
              username.count > 2,
              let bio = bio,
              bio.count > 1,
              imageData != nil else {
            isFormVaild = false
            return
        }
        
        isFormVaild = true
    }
    
    func uploadAvatar(){
        guard let imageData = imageData else {return}
        CloudinaryManager.shared.uplaodImage(upload: imageData)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.error = error.localizedDescription
                case  .finished:
                    self?.updateUserData()
                }
            } receiveValue: {[weak self] urlString in
                self?.avatarPath = urlString
            }
            .store(in: &subscription)
    }
    
    
    private func updateUserData(){
        guard let displayName,
              let username,
              let avatarPath,
              let bio,
              let id = Auth.auth().currentUser?.uid else {return}
        
        let updatedFields: [String : Any] = [
            "displayName" : displayName,
            "username": username,
            "bio": bio,
            "avatarPath": avatarPath,
            "isUserOnboard": true
        ]
        
        DataBaseManager.shared.collectionUsers(updateFields: updatedFields, for: id)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] onboardingState in
                self?.isOnboardingDone = onboardingState
            }
            .store(in: &subscription)
    }
}
