//
//  AuthView.swift
//  SocialCademy
//
//  Created by Michał Gerlach on 26/10/2022.
//

import SwiftUI

struct AuthView: View {
    // ----------- Variables --------------
    @StateObject var viewModel = AuthViewModel()
    
    // ----------- View post or Sign In / Create Account ----------
    var body: some View {
        if let viewModelFactory = viewModel.makeViewModelFactory() {
            MainTabView()
                .environmentObject(viewModelFactory)
        } else {
            NavigationView {
                SignInForm(viewModel: viewModel.makeSignInViewModel()) {
                    NavigationLink("Create Account", destination: CreateAccountForm(viewModel: viewModel.makeCreateAccountViewModel()))
                }
            }
        }
    }
}

// ------------- View: Sign In --------------
private extension AuthView {
    struct SignInForm<Footer: View>: View {
        @StateObject var viewModel: AuthViewModel.SignInViewModel
        @ViewBuilder let footer: () -> Footer
        
        var body: some View {
            Form {
                TextField("Email", text: $viewModel.email)
                    .textContentType(.emailAddress)
                SecureField("Password", text: $viewModel.password)
                    .textContentType(.password)
            } footer: {
                Button("Sign In", action: viewModel.submit)
                    .buttonStyle(.primary)
                footer()
                    .padding()
            }
            .alert("Cannot Sign In", error: $viewModel.error)
            .disabled(viewModel.isWorking)
            .onSubmit(viewModel.submit)
        }
    }
}

// ----------- View: Create Account -------------
private extension AuthView {
    struct CreateAccountForm: View {
        @Environment(\.dismiss) private var dismiss
        @StateObject var viewModel: AuthViewModel.CreateAccountViewModel
        
        var body: some View {
            Form {
                TextField("Name", text: $viewModel.name)
                    .textContentType(.name)
                    .textInputAutocapitalization(.words)
                TextField("Email", text: $viewModel.email)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                SecureField("Password", text: $viewModel.password)
                    .textContentType(.newPassword)
            } footer: {
                Button("Create Account", action: viewModel.submit)
                    .buttonStyle(.primary)
                Button("Sign In", action: dismiss.callAsFunction)
                    .padding()
            }
            .alert("Cannot Create Account", error: $viewModel.error)
            .disabled(viewModel.isWorking)
            .onSubmit(viewModel.submit)
            
        }
    }
        
}

//  ------------ Styled form -----------------
//                 (used above)
private extension AuthView {
    struct Form<Content: View, Footer: View>: View {
        @ViewBuilder let content: () -> Content
        @ViewBuilder let footer: () -> Footer
        
        var body: some View {
            VStack {
                Text("Socialcademy")
                    .font(.title.bold())
                content()
                    .padding()
                    .background(Color.secondary.opacity(0.15))
                    .cornerRadius(10)
                footer()
            }
            .navigationBarHidden(true)
            .padding()
        }
    }
}


struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
