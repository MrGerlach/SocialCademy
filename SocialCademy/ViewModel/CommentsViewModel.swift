//
//  CommentsViewModel.swift
//  SocialCademy
//
//  Created by Michał Gerlach on 06/11/2022.
//

import Foundation

@MainActor
class CommentsViewModel: ObservableObject {
    // ------------------ Variables ---------------------------
    
    @Published var comments: Loadable<[Comment]> = .loading
    
    private let commentsRepository: CommentsRepositoryProtocol
    
    init(commentsRepository: CommentsRepositoryProtocol) {
        self.commentsRepository = commentsRepository
    }
    
    // ------------------ Functions ---------------------------
    func fetchComments() {
        Task {
            do {
                comments = .loaded(try await commentsRepository.fetchComments())
            } catch {
                print("[CommentsViewModel] Cannot fetch comments: \(error)")
                      comments = .error(error)
            }
        }
    }
    
    func makeNewCommentViewModel() -> FormViewModel<Comment> {
        return FormViewModel<Comment> (
            initialValue: Comment(content: "", author: commentsRepository.user),
            action: { [weak self] comment in
                try await self?.commentsRepository.create(comment)
                self?.comments.value?.insert(comment, at: 0)
            }
        )
    }
    
    func makeCommentRowViewModel(for comment: Comment) -> CommentRowViewModel {
        let deleteAction = { [weak self] in
            try await self?.commentsRepository.delete(comment)
            self?.comments.value?.removeAll { $0.id == comment.id }
        }
        return CommentRowViewModel(comment: comment, deleteAction: commentsRepository.canDelete(comment) ? deleteAction: nil)
    }
    /// This sets up the CommentRowViewModel for the given comment. The delete action removes the comment from Cloud Firestore using the CommentsRepository and from the list by updating the comments property.
    /// Then, it initializes the view model, using the canDelete(_:) method of the CommentsRepository to provide the delete action only when authorized.
    
}
