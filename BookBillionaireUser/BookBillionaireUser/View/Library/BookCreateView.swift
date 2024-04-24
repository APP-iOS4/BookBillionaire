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
    @State var book: Book = Book()
    @EnvironmentObject var bookService: BookService
    @EnvironmentObject var userService: UserService
    @Environment(\.dismiss) private var dismiss
    @State private var isShowingSheet: Bool = false
    @State private var selectedImage: UIImage?
    private let viewType: ViewType
    
    enum ViewType {
        case input
        case searchResult(searchBook: SearchBook)
        case edit(book: Book)
        
        var navigationTitle: String {
            switch self {
            case .input, .searchResult:
                return "책 등록"
            case .edit:
                return "책 편집"
            }
        }
    }
    
    // ViewType에 따른 초기값
    init(viewType: ViewType) {
        self.viewType = viewType
        
        switch viewType {
        case .searchResult(let searchBook):
            _book = State(initialValue: Book(ownerID: "", ownerNickname: "", isbn: searchBook.isbn, title: searchBook.title, contents: searchBook.contents, authors: searchBook.authors, thumbnail: searchBook.thumbnail, rentalState: .rentalAvailable))
        case .input:
            _book = State(initialValue: Book())
        case .edit(let book):
            _book = State(initialValue: book)
        }
    }
    
    var body: some View {
        VStack {
            BookInfoAddView(book: $book, selectedImage: $selectedImage)
            DescriptionView(book: $book)
            Button {
                uploadPhoto()
                assignCurrentUserIDToBook(book: &book)
                updateBook()
                dismiss()
            } label: {
                Text("완료")
            }
            .buttonStyle(AccentButtonStyle())
            .disabled(isBookEmpty(book: book))
            .padding()
            Spacer()
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationTitle(viewType.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // 책 업데이트
    private func updateBook() {
        Task {
            switch viewType {
            case .edit:
                await bookService.updateBookByID(book.id, book: book)
            case .input, .searchResult:
                _ = bookService.registerBook(book)
            }
        }
    }
    // 현재 유저정보 할당 함수
    private func assignCurrentUserIDToBook(book: inout Book) {
        book.ownerID = userService.currentUser.id
        book.ownerNickname = userService.currentUser.nickName
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
        let _ = fileRef.putData(imageData!, metadata: nil) { metadata, error in
            if error == nil && metadata != nil {
            } else if let error = error {
                print("Error uploading image: \(error)")
            }
        }
    }
}

#Preview {
    NavigationStack {
        BookCreateView(viewType: .input)
    }
}

