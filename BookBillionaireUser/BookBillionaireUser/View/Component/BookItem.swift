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
    let imageChache = ImageCache.shared
    @State private var imageUrl: URL?
    @State private var loadedImage: UIImage?
    
    var body: some View {
        HStack(alignment: .top) {
            //책 이미지
            if let url = imageUrl, !url.absoluteString.isEmpty {
                Image(uiImage: loadedImage ?? UIImage(named: "default")!)
                    .resizable()
                    .frame(width: 100, height: 140)
                    .onAppear {
                        ImageCache.shared.getImage(for: url) { image in
                            loadedImage = image
                        }
                    }
            } else {
                Image("default")
                    .resizable()
                    .frame(width: 100, height: 140)
            }
                // 책 정보
                VStack(alignment: .leading) {
                    Text(book.title)
                        .monospaced()
                        .padding(.bottom, 5)
                        .font(.subheadline)
                        .bold()
                    Text("저서정보")
                        .fontWeight(.semibold)
                    if book.authors.isEmpty {
                        Text("\(book.translators?.joined(separator: ", ") ?? "")")
                        Text("\(book.publisher ?? "출판사 정보 없음")")
                    } else {
                        Text("\(book.authors.joined(separator: ", "))")
                        Text("\(book.publisher ?? "출판사 정보 없음")")
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
                // Firebase Storage 경로 URL 다운로드
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
    BookItem(book: Book(ownerID: "", ownerNickname: "사용자닉네임", title: "제목", contents: "내용", authors: ["작가"], rentalState: .rentalAvailable))
}
