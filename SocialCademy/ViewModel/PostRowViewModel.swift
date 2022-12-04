//
//  PostRowViewModel.swift
//  SocialCademy
//
//  Created by Michał Gerlach on 21/10/2022.
//

import Foundation

@MainActor
@dynamicMemberLookup
class PostRowViewModel: ObservableObject, StateManager {
    
    // --------------- Variables ----------------
    typealias Action = () async throws -> Void
    
    @Published var post: Post
    @Published var error: Error?
    
    private let deleteAction: Action?
    private let favoriteAction: Action
    
    init(post: Post, deleteAction: Action?, favoriteAction: @escaping Action) {
        self.post = post
        self.deleteAction = deleteAction
        self.favoriteAction = favoriteAction
    }
    
    subscript<T>(dynamicMember keyPath: KeyPath<Post, T>) -> T {
        post[keyPath: keyPath]
    }
    // ---------------------- Functions -------------------------------
    func deletePost() {
        guard let deleteAction = deleteAction else {
                    preconditionFailure("Cannot delete post: no delete action provided")
                }
                withStateManagingTask(perform: deleteAction)
    }
    
    func favoritePost() {
        withStateManagingTask(perform: favoriteAction)
    }
    
    
}
