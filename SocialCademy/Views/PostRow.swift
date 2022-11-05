//
//  PostRow.swift
//  SocialCademy
//
//  Created by Michał Gerlach on 10/10/2022.
//

import SwiftUI

struct PostRow: View {
    // ------- Variables -------
    @ObservedObject var viewModel: PostRowViewModel
    @State private var showConfirmationDialog = false

    
// --------------------------------- Body -----------------------------------------
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            // -------- Post Content ----------
            HStack {
                AuthorView(author: viewModel.author)
                Spacer()
                Text(viewModel.timestamp.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
            }
            .foregroundColor(.gray)
            Text(viewModel.title)
                .font(.title3)
                .fontWeight(.semibold)
            Text(viewModel.content)
            
            //  ----------- Buttons locations -------------
            HStack {
                FavoriteButton(isFavorite: viewModel.isFavorite, action: {viewModel.favoritePost()})
                Spacer()
                Button(role: .destructive, action: {
                    showConfirmationDialog = true
                }) {
                    Label("Delete", systemImage: "trash")
                }
                .labelStyle(.iconOnly)
            }
        }
        .padding()
        
        // ---------------- Delete Button ------------------------
        .confirmationDialog("Are you sure you want to delete this post?", isPresented: $showConfirmationDialog, titleVisibility: .visible) {
            Button("Delete", role: .destructive, action: {viewModel.deletePost()})
        }
        .alert("Cannot Delete Post", error: $viewModel.error)
    }
}

// ---------------- Favorite Button --------------------
private extension PostRow {
    struct FavoriteButton: View {
        let isFavorite: Bool
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                if isFavorite {
                    Label("Remove from Favorites", systemImage: "heart.fill")
                } else {
                    Label("Add to Favorites", systemImage: "heart")
                }
            }
            .foregroundColor(isFavorite ? .red : .gray)
            .animation(.default, value: isFavorite)
        }
    }
}

// ----------------- User's posts view ---------------
private extension PostRow {
    struct AuthorView: View {
        let author: User
        
        @EnvironmentObject private var factory: ViewModelFactory
        
        var body: some View {
            NavigationLink {
                PostList(viewModel: factory.makePostsViewModel(filter: .author(author)))
            } label: {
                Text(author.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
        }
    }
}

struct PostRow_Previews: PreviewProvider {
    static var previews: some View {
        PostRow(viewModel: PostRowViewModel(post: Post.testPost, deleteAction: {}, favoriteAction: {}))
                .environmentObject(ViewModelFactory.preview)
                .previewLayout(.sizeThatFits)
    }
}
