//
//  RentalCreateView.swift
//  BookBillionaireUser
//
//  Created by Woo Sung jong on 4/17/24.
//

import SwiftUI
import BookBillionaireCore

struct RentalCreateView: View {
    var book: Book
    @State var rental: Rental = Rental()
    @EnvironmentObject var bookService: BookService
    let rentalService: RentalService = RentalService()
    @Environment(\.dismiss) var dismiss
    
    init(book: Book) {
        self.book = book
        
        rental.bookOwner = book.ownerID
        self.book.rental = rental.id
        rental.bookID = book.id
    }
    var body: some View {
        VStack {
            HStack {
                BookItem(book: book)
                Spacer()
            }
            RentalInfoView(rental: $rental)
            Button {
                updateBook()
                _ = rentalService.registerRental(rental)
                dismiss()
            } label: {
                Text("완료")
            }
            .buttonStyle(AccentButtonStyle())
            .padding()
            Spacer()
        }
        .navigationTitle("대여 상태 등록")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // 책 업데이트
    private func updateBook() {
        Task {
            await bookService.updateBookByID(book.id, book: book)
        }
    }
}

#Preview {
    NavigationStack {
        RentalCreateView(book: Book())
            .environmentObject(BookService())
    }
}
