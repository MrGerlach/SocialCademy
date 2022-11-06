//
//  PostView.swift
//  SocialCademy
//
//  Created by Michał Gerlach on 10/10/2022.
//

import SwiftUI

struct PostList: View {
    
    // ------------- Variables ------------------
    @StateObject var viewModel: PostsViewModel
    
    @State private var searchText = ""
    @State private var showNewPostForm = false
    
    // ---------------- Body ------------------
    var body: some View {
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
                    ScrollView {
                        ForEach(posts) { post in
                    if searchText.isEmpty || post.contains(searchText) {
                       PostRow(viewModel: viewModel.makePostRowViewModel(for: post))
                       }
                    }
                    .searchable(text: $searchText)
                    .animation(.default, value: posts)
                    }
                    
                }
            }
                .navigationTitle(viewModel.title)
                .onAppear {
                viewModel.fetchPosts()
                }
                .sheet(isPresented: $showNewPostForm) {
                NewPostForm(viewModel: viewModel.makeNewPostsViewModel())
                }
            // ------------- New Post button --------------
                .toolbar {
                Button {
                    showNewPostForm = true
                } label: {
            Label("New Post", systemImage: "square.and.pencil")
                }
                }
            
            }
    
}

extension PostList {
    struct RootView: View {
        @StateObject var viewModel: PostsViewModel
        
        var body: some View {
            NavigationView {
                PostList(viewModel: viewModel)
            }
        }
    }
}
            
// --------------------- DANGER !!! ----------------------------
//                       DEBUG AREA
//                          :)
  #if DEBUG
struct PostsList_Previews: PreviewProvider {
    static var previews: some View {
        ListPreview(state: .loaded([Post.testPost]))
        ListPreview(state: .empty)
        ListPreview(state: .error)
        ListPreview(state: .loading)
    }

    @MainActor
    private struct ListPreview: View {
        let state: Loadable<[Post]>

        var body: some View {
            let postsRepository = PostRepositoryStub(state: state)
            let viewModel = PostsViewModel(postsRepository: postsRepository)
            NavigationView {
                PostList(viewModel: viewModel)
                    .environmentObject(ViewModelFactory.preview)
            }
            
        }
    }
}
#endif
