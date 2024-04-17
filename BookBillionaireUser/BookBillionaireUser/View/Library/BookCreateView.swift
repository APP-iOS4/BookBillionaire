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
    @EnvironmentObject var bookService: BookService
    let rentalService: RentalService = RentalService()
    @State var book: Book = Book(owenerID: "", title: "", contents: "", authors: [""], thumbnail: "", rentalState: .rentalAvailable)
    @State var rental: Rental = Rental()
    @Environment(\.dismiss) var dismiss
    @State var isShowingSheet: Bool = false
    @State private var selectedImage: UIImage?
    
    init(searchBook: SearchBook? = nil) {
            if let searchBook = searchBook {
                _book = State(initialValue: Book(owenerID: "", title: searchBook.title, contents: searchBook.contents, authors: searchBook.authors, thumbnail: searchBook.thumbnail, rentalState: .rentalAvailable))
            } else {
                _book = State(initialValue: Book(owenerID: "", title: "", contents: "", authors: [""], thumbnail: "", rentalState: .rentalAvailable))
            }
        }
    
    var body: some View {
        ScrollView {
            VStack {
                BookInfoAddView(book: $book, selectedImage: $selectedImage)
                if book.rentalState == .rentalAvailable {
                    RentalPeriodView(rental: $rental)
                    DescriptionView(book: $book)
                }
                Button("완료") {
                    if let user = AuthViewModel.shared.currentUser {
                    uploadPhoto()
                        book.ownerID = user.uid
                        rental.bookOwner = user.uid
                    }
                    if book.rentalState == .rentalAvailable {
                        rental.id = UUID().uuidString
                        book.rental = rental.id
                        _ = rentalService.registerRental(rental)
                    }
                    book.id = UUID().uuidString
                    _ = bookService.registerBook(book)
                    dismiss()
                }
                .buttonStyle(AccentButtonStyle())
                .disabled(book.rentalState == .rentalAvailable ? (book.title.isEmpty || book.contents.isEmpty || book.authors.first!.isEmpty) : (book.title.isEmpty || book.authors.first!.isEmpty))
                .padding()
            }
            SpaceBox()
        }
        .onChange(of: book.rentalState) { _ in
            book.contents = ""
        }
        .navigationTitle("책 등록")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func uploadPhoto() {
        guard selectedImage != nil else {
            return
        }
        let storageRef = Storage.storage().reference()
        let imageData = selectedImage!.jpegData(compressionQuality: 0.8)
        guard imageData != nil else {
            return
        }
        let path = "images/\(UUID().uuidString).jpg"
        book.thumbnail = path
        let fileRef = storageRef.child(path)
        let uploadTask = fileRef.putData(imageData!, metadata: nil) { metadata, error in
            if error == nil && metadata != nil {
            } else if let error = error {
                // Handle unsuccessful upload
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

