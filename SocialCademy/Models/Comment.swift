//
//  Comment.swift
//  SocialCademy
//
//  Created by Michał Gerlach on 06/11/2022.
//

import Foundation

struct Comment: Identifiable, Codable, Equatable {
    var content: String
    var author: User
    var timestamp = Date()
    var id = UUID()
}

extension Comment {
    static let testComment = Comment(content: "lorem ipsum dolor set amet.", author: User.testUser)
}
