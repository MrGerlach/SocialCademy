//
//  PostView.swift
//  SocialCademy
//
//  Created by Michał Gerlach on 10/10/2022.
//

import SwiftUI

struct PostList: View {
    @StateObject var viewModel = PostsViewModel()
    @State private var searchText = ""
    @State private var showNewPostForm = false
    
    var body: some View {
        NavigationView {
            Group {
                switch viewModel.posts {
                case .loading:
                    ProgressView()
                    
                case let .error(error):
                    EmptyListView(
                        title: "Cannot Load Posts",
                        message: error.localizedDescription,
                        retryAction: {
                            viewModel.fetchPosts()
                        })
                    
                case .empty:
                    EmptyListView(
                        title: "No Posts",
                        message: "There aren't any posts yet."
                    )
                    
                case let .loaded(posts):
                    List(posts) { post in
                        if searchText.isEmpty || post.contains(searchText) {
                            PostRow(viewModel: viewModel.makePostRowViewModel(for: post))
                        }
                    }
                .searchable(text: $searchText)
                .animation(.default, value: posts)
                }
            }
            .navigationTitle("Posts")
            .toolbar {
                Button {
                    showNewPostForm = true
                } label: {
                    Label("New Post", systemImage: "square.and.pencil")
                }
            }
        }
        .onAppear {
            viewModel.fetchPosts()
        }
        .sheet(isPresented: $showNewPostForm) {
            NewPostForm(createAction: viewModel.makeCreateAction())
        }
    }
}

struct PostList_Previews: PreviewProvider {
    static var previews: some View {
        PostList()
    }
}
//    #if DEBUG
//    struct PostList_Previews: PreviewProvider {
//        @MainActor
//        private struct ListPreview: View {
//            let state: Loadable<[Post]>
//
//            var body: some View {
//                let postsRepository = PostRepositoryStub(state: state)
//                let viewModel = PostsViewModel(postsRepository: postsRepository)
//                PostList(viewModel: viewModel)
//            }
//        }
//        static var previews: some View {
//            ListPreview(state: .loaded([Post.testPost]))
//            ListPreview(state: .empty)
//            ListPreview(state: .error)
//            ListPreview(state: .loading)
//        }
//    }
//    #endif
//
