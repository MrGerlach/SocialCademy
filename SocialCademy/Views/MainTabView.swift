//
//  MainTabView.swift
//  SocialCademy
//
//  Created by Michał Gerlach on 22/10/2022.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            PostList()
                .tabItem {
                    Label("Posts", systemImage: "list.dash")
                }
            PostList(viewModel: PostsViewModel(filter: .favorites))
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
