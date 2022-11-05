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
}

extension User {
    static let testUser = User(id: "", name: "Michael Scott")
}
