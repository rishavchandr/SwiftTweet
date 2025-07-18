//
//  ProfileDataFormViewModel.swift
//  twitterClone
//
//  Created by Rishav chandra on 18/07/25.
//

import Foundation


final class ProfileDataFormViewModel: ObservableObject {
    
    @Published var displayName: String?
    @Published var username: String?
    @Published var bio: String?
    @Published var avatarPath: String?
}
