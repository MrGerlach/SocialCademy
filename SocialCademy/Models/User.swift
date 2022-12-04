//
//  User.swift
//  SocialCademy
//
//  Created by Michał Gerlach on 05/11/2022.
//

import Foundation

struct User: Identifiable, Codable, Equatable {
    var id: String
    var name: String
    var imageURL: URL?
}

extension User {
    static let testUser = User(id: "", name: "Michael Scott", imageURL: URL(string: "https://source.unsplash.com/lw9LrnpUmWw/480x480"))
}
