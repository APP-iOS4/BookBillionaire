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
    
    var body: some View {
            HStack(alignment: .top) {
                // 책 이미지 부분
                if let url = imageUrl {
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .frame(width: 100, height: 140)
                    } placeholder: {
                        ProgressView()
                    }
                } else {
                    Image("default")
                        .resizable()
                        .frame(width: 100, height: 140)
                }
                
                // 책 정보 부분
                VStack(alignment: .leading) {
                    Text(book.title)
                        .font(.subheadline)
                        .padding(.bottom, 5)
                    if book.authors.isEmpty {
                        Text("\(book.title)")
                        Text("\(book.translators?.joined(separator: ", ") ?? "")")
                    } else {
                        Text("\(book.title)")
                        Text("\(book.authors.joined(separator: ", "))")
                    }
                }
                .padding(.bottom, 10)
                .font(.caption)
                .multilineTextAlignment(.leading)
                .foregroundStyle(Color.primary)
            }
            .padding(.leading, 10)

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


#Preview {
    BookItem(book: Book(ownerID: "", title: "제목", contents: "내용", authors: ["작가"], rentalState: .rentalAvailable))
}
