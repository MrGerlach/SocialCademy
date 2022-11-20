//
//  NewPostForm.swift
//  SocialCademy
//
//  Created by Michał Gerlach on 10/10/2022.
//

import SwiftUI

struct NewPostForm: View {
    // ------- Variables ------
//    typealias CreateAction = (Post) async throws -> Void
    
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: FormViewModel<Post>
    
//    let createAction: CreateAction
    
    // ------------ Body ---------------
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Title", text: $viewModel.title)
                }
                ImageSection(imageURL: $viewModel.imageURL)
                Section("Content") {
                    TextEditor(text: $viewModel.content)
                        .multilineTextAlignment(.leading)
                }
                Button(action: viewModel.submit) {
                    if viewModel.isWorking {
                        ProgressView()
                        } else {
                        Text("Create Post")
                    }
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .padding()
                .listRowBackground(Color.accentColor)
            }
            .onChange(of: viewModel.isWorking) { isWorking in
                guard !isWorking, viewModel.error == nil else { return }
                dismiss() /// view will only be dismissed when the create action has been run successfully
            }
            .onSubmit(viewModel.submit)
            .navigationTitle("New Post")
        }
        .disabled(viewModel.isWorking)
        .alert("Cannot create post!", error: $viewModel.error)
        }
    }
    
    // -------- Functions ---------
//    private func createPost() {
//        Task {
//            state = .working
//            do {
//                try await createAction(post)
//                dismiss()
//            } catch {
//                print("[NewPostForm] Cannot create post: \(error)")
//                state = .error
//            }
//        }
//    }
    
    // --------- Enums -----------
//    enum FormState {
//        case idle, working, error
//
//        var isError: Bool {
//            get {
//                self == .error
//            }
//            set {
//                guard !newValue else {return}
//                self = .idle
//            }
//        }
//    }
//}

// ------------------ Extensions -------------------------
private extension NewPostForm {
    struct ImageSection: View {
        @Binding var imageURL: URL?
        
        var body: some View {
            Section("Image") {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } placeholder: {
                    EmptyView()
                }
                ImagePickerButton(imageURL: $imageURL) {
                    Label("Choose Image", systemImage: "photo.fill")
                }
            }
        }
    }
}

struct NewPostForm_Previews: PreviewProvider {
    static var previews: some View {
        NewPostForm(viewModel: FormViewModel(initialValue: Post.testPost, action: { _ in }))
    }
}
