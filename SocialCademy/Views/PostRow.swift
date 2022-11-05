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

    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
   // -------------------- Post Content ----------------------
            HStack {
                Text(viewModel.author.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Spacer()
                Text(viewModel.timestamp.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
            }
            .foregroundColor(.gray)
            Text(viewModel.title)
                .font(.title3)
                .fontWeight(.semibold)
            Text(viewModel.content)
            
    //  --------------------- Buttons locations ----------------------------
            HStack {
                FavoriteButton(isFavorite: viewModel.isFavorite, action: {viewModel.favoritePost()})
                Spacer()
                Button(role: .destructive, action: {
                    showConfirmationDialog = true
                }) {
                    Label("Delete", systemImage: "trash")
                }
                .labelStyle(.iconOnly)
                .buttonStyle(.borderless)
            }
        }
        .padding(.vertical)
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


struct PostRow_Previews: PreviewProvider {
    static var previews: some View {
        List {
            PostRow(viewModel: PostRowViewModel(post: Post.testPost, deleteAction: {}, favoriteAction: {}))
        }
    }
}
