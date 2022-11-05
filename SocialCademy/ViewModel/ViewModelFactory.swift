//
//  ViewModelFactory.swift
//  SocialCademy
//
//  Created by Michał Gerlach on 05/11/2022.
//
//  Used to supply views with their dependencies.

import Foundation

@MainActor
class ViewModelFactory: ObservableObject {
    // ------ Variables ------
    private let user: User
    
    init(user: User) {
        self.user = user
    }
    // -------- Functions ---------
    func makePostsViewModel(filter: PostsViewModel.Filter = .all) -> PostsViewModel {
        return PostsViewModel(filter: filter, postsRepository: PostsRepository(user: user))
    }
}

#if DEBUG
extension ViewModelFactory {
    static let preview = ViewModelFactory(user: User.testUser)
}
#endif
