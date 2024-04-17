//
//  BookCreateView.swift
//  BookBillionaireUser
//
//  Created by Woo Sung jong on 4/4/24.
//

import SwiftUI
import BookBillionaireCore
import FirebaseStorage
import FirebaseFirestore

struct BookCreateView: View {
    @State var book: Book = Book(ownerID: "", title: "", contents: "", authors: [""], thumbnail: "", rentalState: .rentalAvailable)
    @EnvironmentObject var bookService: BookService
    @Environment(\.dismiss) private var dismiss
    @State private var isShowingSheet: Bool = false
    @State private var selectedImage: UIImage?
    
    // 선택적 파라미터 초기값 설정
    init(searchBook: SearchBook? = nil) {
        if let searchBook = searchBook {
            _book = State(initialValue: Book(ownerID: "", isbn: searchBook.isbn, title: searchBook.title, contents: searchBook.contents, authors: searchBook.authors, thumbnail: searchBook.thumbnail, rentalState: .rentalAvailable))
        } else {
            _book = State(initialValue: Book(ownerID: "", title: "", contents: "", authors: [""], thumbnail: "", rentalState: .rentalAvailable))
        }
    }
    
    var body: some View {
        VStack {
            BookInfoAddView(book: $book, selectedImage: $selectedImage)
            DescriptionView(book: $book)
            Button {
                uploadPhoto()
                assignCurrentUserIDToBook(book: &book)
                book.id = UUID().uuidString
                _ = bookService.registerBook(book)
                dismiss()
            } label: {
                Text("완료")
            }
            .buttonStyle(AccentButtonStyle())
            .disabled(isBookEmpty(book: book))
            .padding()
            Spacer()
        }
        .navigationTitle("책 등록")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // 현재 유저정보 할당 함수
    private func assignCurrentUserIDToBook(book: inout Book) {
        if let currentUser = AuthViewModel.shared.currentUser {
            book.ownerID = currentUser.uid
        }
    }
    
    // 버튼 활성화 조건 함수
    private func isBookEmpty(book: Book) -> Bool {
        return book.title.isEmpty || book.contents.isEmpty || book.authors.isEmpty
    }
    
    // Firebase Storage 업로드 함수
    private func uploadPhoto() {
        guard selectedImage != nil else {
            return
        }
        // Firebase Storage jpeg로 변환
        let storageRef = Storage.storage().reference()
        let imageData = selectedImage!.jpegData(compressionQuality: 0.8)
        guard imageData != nil else {
            return
        }
        // Firebase Storage 경로 설정
        let path = "images/\(UUID().uuidString).jpg"
        book.thumbnail = path
        let fileRef = storageRef.child(path)
        let uploadTask = fileRef.putData(imageData!, metadata: nil) { metadata, error in
            if error == nil && metadata != nil {
            } else if let error = error {
                print("Error uploading image: \(error)")
            }
        }
    }
}

#Preview {
    NavigationStack {
        BookCreateView()
    }
}

