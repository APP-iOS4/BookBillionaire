//
//  BookDetailImageView.swift
//  BookBillionaireUser
//
//  Created by 홍승표 on 4/11/24.
//

import SwiftUI
import FirebaseStorage
import BookBillionaireCore

struct BookDetailImageView: View {
    @Environment(\.colorScheme) var colorScheme
    let book: Book
    let imageChache = ImageCache.shared
    @State private var imageUrl: URL?
    @State private var loadedImage: UIImage?
    
    var body: some View {
        ZStack{
            if let url = imageUrl, !url.absoluteString.isEmpty {
                Image(uiImage: loadedImage ?? UIImage(named: "default")!)
                        .resizable(resizingMode: .stretch)
                        .ignoresSafeArea()
                        .blur(radius: 8.0,opaque: true)
                        .background(Color.gray)
                    .onAppear {
                        ImageCache.shared.getImage(for: url) { image in
                            loadedImage = image
                        }
                    }
            } else {
                Image("default")
                        .resizable(resizingMode: .stretch)
                        .ignoresSafeArea()
                        .blur(radius: 8.0,opaque: true)
                        .background(Color.gray)
            }
            
            VStack(alignment: .center){
                UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 25.0, topTrailing: 25.0))
                    .frame(height: 100)
                    .foregroundStyle(colorScheme == .dark ? .black : .white)
                    .padding(.top, 200)
            }
            
            GeometryReader { geometry in
                Image(uiImage: loadedImage ?? UIImage(named: "default")!)
                    .resizable()
                    .ignoresSafeArea()
                    .frame(width: 200)
                    .background(Color.gray)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 1.5)
            }
        }
        Rectangle()
            .frame(height: 50)
            .foregroundStyle(.clear)
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
    BookDetailImageView(book: Book(ownerID: "", ownerNickname: "", title: "책제목", contents: "책내용", authors: ["작가"], rentalState: .rentalAvailable))
}
