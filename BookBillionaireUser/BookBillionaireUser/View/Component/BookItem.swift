//
//  BookItem.swift
//  BookBillionaireUser
//
//  Created by Woo Sung jong on 4/9/24.
//

import SwiftUI
import BookBillionaireCore
import FirebaseStorage

struct BookItem: View {
    var book: Book
    @State private var imageUrl: URL?

    var body: some View {
        NavigationLink(value: book) {
            HStack(alignment: .top) {
                if let url = imageUrl {
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .frame(width: 100, height: 120)
                            .background(Color.gray)
                    } placeholder: {
                        ProgressView()
                    }
                } else {
                    Image("default")
                        .resizable()
                        .frame(width: 100, height: 120)
                        .background(Color.gray)
                }
                VStack(alignment: .leading) {
                    Text(book.title)
                    Text(book.authors.joined(separator: ", "))
                    Spacer()
                }
                .foregroundStyle(Color.black)
                Spacer()
            }
        }
        .onAppear {
            if book.thumbnail.hasPrefix("http://") || book.thumbnail.hasPrefix("https://") {
                // book.thumbnail is a web URL
                imageUrl = URL(string: book.thumbnail)
            } else {
                // book.thumbnail is a Firebase Storage path
                let storageRef = Storage.storage().reference(withPath: book.thumbnail)
                storageRef.downloadURL { (url, error) in
                    if let error = error {
                        // Handle any errors
                        print("Error getting download URL: \(error)")
                    } else if let url = url {
                        // Use the download URL
                        imageUrl = url
                    }
                }
            }
        }
    }
}
