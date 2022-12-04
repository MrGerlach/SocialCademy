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
    private let authService: AuthService
    
    init(user: User, authService: AuthService) {
        self.user = user
        self.authService = authService
    }
    
    // -------- Functions ---------
    func makePostsViewModel(filter: PostsViewModel.Filter = .all) -> PostsViewModel {
        return PostsViewModel(filter: filter, postsRepository: PostsRepository(user: user))
    }
    
    func makeCommentsViewModel(for post: Post) -> CommentsViewModel {
        return CommentsViewModel(commentsRepository: CommentsRepository(user: user, post: post))
    }
    
    func makeProfileViewModel() -> ProfileViewModel {
        return ProfileViewModel(user: user, authService: authService)
    }
    
}


// --------------------- DANGER !!! ----------------------------
//                       DEBUG AREA
//                          :)
#if DEBUG
extension ViewModelFactory {
    static let preview = ViewModelFactory(user: User.testUser, authService: AuthService())
}
#endif
