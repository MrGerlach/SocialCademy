//
//  CommentRowViewModel.swift
//  SocialCademy
//
//  Created by Michał Gerlach on 06/11/2022.
//

import SwiftUI

@MainActor
@dynamicMemberLookup

class CommentRowViewModel: ObservableObject, ErrorHandler {
    
    // ---------------- Variables ------------------------
    @Published var comment: Comment
    @Published var error: Error?
    
    typealias Action = () async throws -> Void
    
    private let deleteAction: Action?
    
    var canDeleteComment: Bool {deleteAction != nil}
    
        // --- subscript the view model as if it were a Comment ---
    subscript<T>(dynamicMember keyPath: KeyPath<Comment, T>) -> T {
        comment[keyPath: keyPath]
    }
    
        // ---- initializer ----
    init(comment: Comment, deleteAction: Action?) {
        self.comment = comment
        self.deleteAction = deleteAction
    }
    
    // ----------------- Functions -------------------------
    func deleteComment() {
        guard let deleteAction = deleteAction else {
            preconditionFailure("Cannot delete comment: no delete action provided")
        }
        withErrorHandlingTask(perform: deleteAction)
    }
    
    
}
