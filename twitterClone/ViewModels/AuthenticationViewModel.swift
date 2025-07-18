//
//  RegisterViewModel.swift
//  twitterClone
//
//  Created by Rishav chandra on 17/07/25.
//

import Foundation
import FirebaseAuth
import Combine


final class AuthenticationViewModel : ObservableObject{
    
    @Published var email: String?
    @Published var password: String?
    @Published var isAuthenticationFormVaild: Bool = false
    @Published var user: User?
    @Published var error: String?
    
    
    private var subscription: Set<AnyCancellable> = []
    
    func vaildateAuthenticationForm() {
        guard let email = email ,
              let password = password else {
            isAuthenticationFormVaild = false
            return
        }
        isAuthenticationFormVaild = isValidEmail(email) && isVaildPassword(password)
    }
    
    func createUser(){
        guard let email = email ,
              let password = password else {
            return
        }
        AuthManager.shared.registerUser(with: email, password: password)
            .handleEvents(receiveOutput: { [weak self] user in
                self?.user = user
            })
            .sink {[weak self] completion in
                
            if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
            }
                
            } receiveValue: { [weak self] user in
                self?.recordUser(for: user)
            }
            .store(in: &subscription)

    }
    
    func recordUser(for user: User){
        DataBaseManager.shared.collectionUser(add: user)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { state in
                print("Adding user to record: \(state)")
                
            }
            .store(in: &subscription)

    }
    
    func loginUser(){
        guard let email = email,
              let password = password else {
            return
        }
        
        AuthManager.shared.loginUser(with: email, password: password)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
                
            } receiveValue: { [weak self] user in
                self?.user = user
            }
            .store(in: &subscription)

    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isVaildPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
    
}
