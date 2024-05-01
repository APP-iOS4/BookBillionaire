//
//  GridCell.swift
//  BookBillionaireAdmin
//
//  Created by YUJIN JEON on 4/24/24.
//

import SwiftUI
import FirebaseStorage
import BookBillionaireCore

struct BookGridCell: View {
    var book: Book
    @State private var imageUrl: URL?
    @State private var loadedImage: Image = Image("default")
    @State var isToggle: Bool = false
    @Binding var selectedBooks: [Book]
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(isToggle ? Color.accentColor : Color.bbBGcolor)
            VStack{
                if let url = imageUrl, !url.absoluteString.isEmpty {
                    loadedImage
                        .resizable()
                        .frame(width: 120, height: 140)
                        .scaledToFill()
                } else {
                    Image("default")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 140)
                }
                Text(book.title)
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
                    .bold()
                Text("소유자: " + book.ownerNickname)
                ZStack {
                    Capsule()
                        .stroke(Color.accentColor)
                        .frame(height: 25)
                    Text( book.bookCategory?.buttonTitle ?? "미설정")
                        .padding(.horizontal)
                }
                .fixedSize()
            }
            .padding(20)
        }
        .onTapGesture {
            isToggle.toggle()
            if isToggle {
                selectedBooks.append(book)
            } else {
                if selectedBooks.contains(book) {
                    selectedBooks.removeAll(where: { $0 == book })
                }
            }
            print("\(selectedBooks)")
        }
        .task {
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
            guard let imageUrl else { return }
            ImageCacheService.shared.getImage(for: imageUrl) { image in
                guard let image else { return }
                loadedImage = Image(uiImage: image)
            }
        }
        
    }
}

