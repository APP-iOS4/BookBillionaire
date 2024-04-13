//
//  BookCreateView.swift
//  BookBillionaireUser
//
//  Created by Woo Sung jong on 4/4/24.
//

import SwiftUI
import BookBillionaireCore

struct BookCreateView: View {
    let bookService: BookService = BookService.shared
    let rentalService: RentalService = RentalService.shared
    @State var book: Book = Book(owenerID: "", title: "", contents: "", authors: [""], thumbnail: "", rentalState: .rentalAvailable)
    @State var rental: Rental = Rental(id: "", bookOwner: "", rentalStartDay: Date(), rentalEndDay: Date())
    @Environment(\.dismiss) var dismiss
    @State var isShowingSheet: Bool = false
    
    var body: some View {
        ScrollView {
            VStack {
                BookInfoAddView(book: $book)
                if book.rentalState == .rentalAvailable {
                    RentalPeriodView(rental: $rental)
                    DescriptionView(book: $book)
                }
                Button("완료") {
                    if let user = AuthViewModel.shared.currentUser {
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
}

#Preview {
    NavigationStack {
        BookCreateView()
    }
}

