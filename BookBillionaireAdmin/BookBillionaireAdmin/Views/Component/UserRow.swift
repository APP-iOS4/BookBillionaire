//
//  UserRow.swift
//  BookBillionaireAdmin
//
//  Created by YUJIN JEON on 4/30/24.
//

import SwiftUI
import FirebaseStorage
import BookBillionaireCore

struct UserRow: View {
    @State private var imageUrl: URL?
    @State private var loadedImage: Image = Image("default")
    @State private var isShowingPicture: Bool = false
    @State private var isShowingAlert: Bool = false
    @EnvironmentObject var bookService: BookService
    @EnvironmentObject var userService: UserService
    @State private var books: [Book] = []
    var user: User
    var body: some View {
        VStack{
            HStack(alignment: .center) {
                VStack {
                    if let url = imageUrl, !url.absoluteString.isEmpty {
                        loadedImage
                            .resizable()
                            .clipShape(Circle())
                            .scaledToFit()
                    }
                }
                .onAppear{
                    loadImage()
                }
                .padding()
                .frame(minWidth: 60, maxWidth: 80)
                .onTapGesture {
                    isShowingPicture = true
                }
                VStack(alignment: .leading) {
                    Text(user.nickName).bold()
                    Text(user.email).monospaced()
                    Text(user.id).monospaced()
                }
                .padding()
                Spacer()
                VStack(alignment: .leading){
                    if books.count > 0 {
                        ForEach(books){ book in
                            VStack(alignment: .leading, spacing: 5) {
                                Text(book.title).bold()
                                Text(book.id).monospaced()
                            }
                            Divider()
                        }
                    } else {
                        Text("보유 책 없음")
                    }
                }.padding(30)
                Spacer()
            }
            Divider().background(Color.accentColor)
        }
        .sheet(isPresented: $isShowingPicture, content: {
            loadedImage.resizable().padding(30)
        })
        .onAppear{
            books = bookService.filterByOwenerID(user.id)
        }
    }
    private func loadImage() {
        let storageRef = Storage.storage().reference(withPath: user.image ?? "profile/defaultUser.jpeg")
        storageRef.downloadURL { (url, error) in
            if let error = error {
                print("Error getting download URL: \(error)")
            } else if let url = url {
                imageUrl = url
            }
        }
        guard let imageUrl else { return }
        ImageCacheService.shared.getImage(for: imageUrl) { image in
            guard let image else { return }
            loadedImage = Image(uiImage: image)
        }
    }
    private func deleteUser(_ user: User) {
        Task {
            await userService.deleteUser(user)
        }
    }
}
