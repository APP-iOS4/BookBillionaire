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
            VStack(alignment: .center) {
                HStack(alignment: .top) {
                    // 책 이미지 부분
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
                    // 책 정보 부분
                    VStack(alignment: .leading) {
                        Text(book.title)
                        Text(book.authors.joined(separator: ", "))
                        Spacer()
                    }
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(Color.primary)
                    Spacer()
                }
            }
        }
        .onAppear {
            // 앞글자에 따라 imageURL에 할당하는 조건
            if book.thumbnail.hasPrefix("http://") || book.thumbnail.hasPrefix("https://") {
                imageUrl = URL(string: book.thumbnail)
            } else {
                // Firebase Storage 경로
                let storageRef = Storage.storage().reference(withPath: book.thumbnail)
                storageRef.downloadURL { (url, error) in
                    if let error = error {
                        print("Error getting download URL: \(error)")
                    } else if let url = url {
                        imageUrl = url
                    }
                }
            }
        }
    }
}
