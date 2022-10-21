//
//  Post.swift
//  SocialCademy
//
//  Created by Michał Gerlach on 08/10/2022.
//

import Foundation

struct Post: Identifiable, Equatable, Codable {
    var id = UUID()
    var title: String
    var content: String
    var authorName: String
    var timestamp = Date()
    var isFavorite = false

    func contains(_ string: String) -> Bool {
        let properties = [title, content, authorName].map {$0.lowercased()}
        let query = string.lowercased()
        let matches = properties.filter { $0.contains(query) }
        return !matches.isEmpty
    }

}


extension Post {
    static let testPost = Post(
        title: "lorem ipsum",
        content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
    authorName: "Jamie Harris")
}
