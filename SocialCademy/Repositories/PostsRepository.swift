//
//  PostsRepository.swift
//  SocialCademy
//
//  Created by Michał Gerlach on 10/10/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import CoreMedia

//  _______________ Protocol ________________

protocol PostsRepositoryProtocol {
    func fetchAllPosts() async throws -> [Post]
    func fetchFavoritePosts() async throws -> [Post]
    func create(_ post: Post) async throws
    func delete(_ post: Post) async throws
    func favorite(_ post: Post) async throws
    func unfavorite(_ post: Post) async throws
    func fetchPosts(by author: User) async throws -> [Post]
    var user: User { get }
}

extension PostsRepositoryProtocol {
    func canDelete(_ post: Post) -> Bool {
        post.author.id == user.id
    }
}

//_________________ Main Part ____________________________

struct PostsRepository: PostsRepositoryProtocol {
    let postsReference = Firestore.firestore().collection("posts_v2")
    let favoritesReference = Firestore.firestore().collection("favorites")
    let user: User
    
    // _______________ fetching posts ____________________
    
     func fetchAllPosts() async throws -> [Post] {
         return try await fetchPosts(from: postsReference)
    }
    
    func fetchFavoritePosts() async throws -> [Post] {
        let favorites = try await fetchFavorites()
        guard !favorites.isEmpty else { return [] }
        return try await postsReference
            .whereField("id", in: favorites.map(\.uuidString))
            .order(by: "timestamp", descending: true)
            .getDocuments(as: Post.self)
            .map { post in
                post.setting(\.isFavorite, to: true)
            }
    }
    
    func fetchPosts(by author: User) async throws -> [Post] {
        return try await fetchPosts(from: postsReference.whereField("author.id", isEqualTo: author.id))
    }
    
    // ______________________________________________________
    //                      Actions
    
    func create(_ post: Post) async throws {
       let document = postsReference.document(post.id.uuidString)
       try await document.setData(from: post)
   }
    
    func delete(_ post: Post) async throws {
        let document = postsReference.document(post.id.uuidString)
        try await document.delete()
    }
    
    func favorite(_ post: Post) async throws {
        let favorite = Favorite(postID: post.id, userID: user.id)
        let document = favoritesReference.document(favorite.id)
        try await document.setData(from: favorite)
    }
    
    func unfavorite(_ post: Post) async throws {
        let favorite = Favorite(postID: post.id, userID: user.id)
        let document = favoritesReference.document(favorite.id)
        try await document.delete()
    }
    
}

// ____________________ Reference _______________________________
private extension DocumentReference {
    func setData<T: Encodable>(from value: T) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            try! setData(from: value) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                continuation.resume()
            }
        }
    }
}
// ---------------- Favoriting posts in cloud -----------------
private extension PostsRepository {
    
    private func fetchPosts(from query: Query) async throws -> [Post] {
        let (posts, favorites) = try await (
            query.order(by: "timestamp", descending: true).getDocuments(as: Post.self), fetchFavorites())
        return posts.map { post in
            post.setting(\.isFavorite, to: favorites.contains(post.id))
        }
    }
    
    struct Favorite: Identifiable, Codable {
        var id: String {
            postID.uuidString + "-" + userID
        }
        let postID: Post.ID
        let userID: User.ID
    }
    
        func fetchFavorites() async throws -> [Post.ID] {
            return try await favoritesReference
                .whereField("userID", isEqualTo: user.id)
                .getDocuments(as: Favorite.self)
                .map(\.postID)
        }
}

// --------------- Helpers ---------------------------
private extension Post {
    func setting<T>(_ property: WritableKeyPath<Post, T>, to newValue: T) -> Post {
        var post = self
        post[keyPath: property] = newValue
        return post
    }
}
private extension Query {
    func getDocuments<T: Decodable>(as type: T.Type) async throws -> [T] {
        let snapshot = try await getDocuments()
        return snapshot.documents.compactMap { document in
            try! document.data(as: type)
        }
    }
}

 //             Post Repository Stub
#if DEBUG
struct PostRepositoryStub: PostsRepositoryProtocol {
    let state: Loadable<[Post]>
    var user = User.testUser
    
    func fetchAllPosts() async throws -> [Post] {
        return try await state.simulate()
    }
    
    func fetchFavoritePosts() async throws -> [Post] {
        return try await state.simulate()
    }
    
    func create(_ post: Post) async throws {}
    
    func delete(_ post: Post) async throws {}
    
    func unfavorite(_ post: Post) async throws {}
    
    func favorite(_ post: Post) async throws {}
    
    func fetchPosts(by author: User) async throws -> [Post] {
        return try await state.simulate()
    }
}
#endif
