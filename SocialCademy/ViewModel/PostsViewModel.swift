//
//  PostsViewModel.swift
//  SocialCademy
//
//  Created by Michał Gerlach on 10/10/2022.
//

import Foundation

@MainActor


class PostsViewModel: ObservableObject {
    
    // ------------- Variables ---------------
    @Published var posts: Loadable<[Post]> = .loading
    
    private let filter: Filter
    private let postsRepository: PostsRepositoryProtocol
    
    init(filter: Filter = .all, postsRepository: PostsRepositoryProtocol) {
        self.filter = filter
        self.postsRepository = postsRepository
    }
    
    // --------------- Functions -------------------
    
//    func makePostRowViewModel(for post: Post) -> PostRowViewModel {
//        return PostRowViewModel(post: post,
//                                deleteAction: { [weak self] in
//            try await self?.postsRepository.delete(post)
//            self?.posts.value?.removeAll {$0.id == post.id }
//        },
//                                favoriteAction: { [weak self] in
//            let newValue = !post.isFavorite
//            try await newValue ? self?.postsRepository.favorite(post) : self?.postsRepository.unfavorite(post)
//
//            guard let i = self?.posts.value?.firstIndex(of: post) else { return }
//            self?.posts.value?[i].isFavorite = newValue})
//    }
    
    func makePostRowViewModel(for post: Post) -> PostRowViewModel {
        let deleteAction = { [weak self] in
            try await self?.postsRepository.delete(post)
            self?.posts.value?.removeAll {$0 == post }
        }
        let favoriteAction = { [weak self] in
            let newValue = !post.isFavorite
            try await newValue ? self?.postsRepository.favorite(post) : self?.postsRepository.unfavorite(post)
            
            guard let i = self?.posts.value?.firstIndex(of: post) else { return }
            self?.posts.value?[i].isFavorite = newValue
        }
        return PostRowViewModel(post: post,
                                deleteAction: postsRepository.canDelete(post) ? deleteAction: nil,
                                favoriteAction: favoriteAction
        )
    }
    
    func makeNewPostsViewModel() -> FormViewModel<Post> {
        return FormViewModel(initialValue: Post(title: "", content: "", author: postsRepository.user),
                             action: { [weak self] post in
            try await self?.postsRepository.create(post)
            self?.posts.value?.insert(post, at: 0)
        })
    } /// returns the FormViewModel with the initialValue set to an empty post.
    
    
//    func makeCreateAction() -> NewPostForm.CreateAction {
//        return { [weak self] post in
//            try await self?.postsRepository.create(post)
//            self?.posts.value?.insert(post, at: 0)
//        }
//    }
    
    func fetchPosts() {
        Task {
            do {
                posts = .loaded(try await postsRepository.fetchPosts(matching: filter))
            } catch {
                print("[PostsViewModel] Cannot fetch posts: \(error)")
                posts = .error(error)
            }
        }
    }
    
    // ----------- Posts type filter ----------
    enum Filter {
        case all, favorites, author(User)
    }
    
    var title: String {
        switch filter {
        case .all:
            return "Posts"
        case .favorites:
            return "Favorites"
        case let .author(author):
            return "\(author.name)'s Posts"
        }
    }
}

private extension PostsRepositoryProtocol {
func fetchPosts(matching filter: PostsViewModel.Filter) async throws -> [Post] {
    switch filter {
    case .all:
        return try await fetchAllPosts()
    case .favorites:
        return try await fetchFavoritePosts()
    case let .author(author):
        return try await fetchPosts(by: author)
    }
}
}


