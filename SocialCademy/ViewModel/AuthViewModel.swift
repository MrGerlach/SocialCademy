//
//  AuthViewModel.swift
//  SocialCademy
//
//  Created by Michał Gerlach on 26/10/2022.
//

import Foundation

@MainActor

class AuthViewModel: ObservableObject {

// ------------ Variables ----------------
    @Published var user: User?
//    @Published var email = ""
//    @Published var password = ""
    
    private let authService = AuthService()
    
    // synchronizing user property with AuthServies's
    init() {
        authService.$user.assign(to: &$user)
    }
    
//    func signIn() {
//        Task {
//            do {
//                try await authService.signIn(email: email, password: password)
//            } catch {
//                print("[AuthViewModel] Cannot sign in: \(error)")
//            }
//        }
//    }
    
    
    // ------------------- Functions ---------------------
    func makeSignInViewModel() -> SignInViewModel {
        return SignInViewModel(action: authService.signIn(email: password:))
    }
    
    func makeCreateAccountViewModel() -> CreateAccountViewModel {
        return CreateAccountViewModel(action: authService.createAccount(name: email: password:))
    }
    
}

// -------------- Views for Sign In / Create Account -------------------
extension AuthViewModel {
    class SignInViewModel: FormViewModel<(email: String, password: String)> {
        convenience init(action: @escaping Action) {
            self.init(initialValue: (email: "", password: ""), action: action)
        }
    }
    
    class CreateAccountViewModel: FormViewModel<(name: String, email: String, password: String)> {
        convenience init(action: @escaping Action) {
            self.init(initialValue: (name: "", email: "", password: ""), action: action)
        }
    }
}
