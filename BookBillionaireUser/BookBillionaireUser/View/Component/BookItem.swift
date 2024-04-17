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
    let book: Book
    @State private var imageUrl: URL?
    @State private var isFavorite: Bool = false

    var body: some View {
        NavigationLink(value: book) {
            HStack(alignment: .top) {
                if let url = imageUrl {
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .frame(width: 100, height: 140)
                            .background(Color.gray)
                    } placeholder: {
                        ProgressView()
                    }
                } else {
                    Image("default")
                        .resizable()
                        .frame(width: 100, height: 140)
                        .background(Color.gray)
                }
                
                VStack(alignment: .leading) {
                    Text(book.title)
                        .font(.subheadline)
                        .padding(.bottom, 5)
                    if book.authors.isEmpty {
                        Text("\(book.title)")
                            .font(.caption)
                        Text("\(book.translators?.joined(separator: ", ") ?? "")")
                            .multilineTextAlignment(.leading)
                            .font(.caption)
                            .padding(.bottom, 10)
                    } else {
                        Text("\(book.title)")
                            .font(.caption)
                        Text("\(book.authors.joined(separator: ", "))")
                            .multilineTextAlignment(.leading)
                            .font(.caption)
                            .padding(.bottom, 10)
                    }
                }
                .padding(.leading, 10)
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

#Preview {
    BookItem(book: Book(owenerID: "", title: "제목", contents: "내용", authors: ["작가"], rentalState: .rentalAvailable))
}
