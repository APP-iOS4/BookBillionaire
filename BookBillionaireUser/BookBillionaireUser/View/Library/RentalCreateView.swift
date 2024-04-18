//
//  RentalCreateView.swift
//  BookBillionaireUser
//
//  Created by Woo Sung jong on 4/17/24.
//

import SwiftUI
import BookBillionaireCore

struct RentalCreateView: View {
    @Binding var book: Book
    @State var rental: Rental = Rental()
    @EnvironmentObject var bookService: BookService
    let rentalService: RentalService = RentalService()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            HStack {
                BookItem(book: book)
                Spacer()
            }
            RentalInfoView(rental: $rental)
            Button {
                _ = bookService.registerBook(book)
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
        .onAppear {
            rental.bookOwner = book.ownerID
            book.rental = rental.id
        }
    }
}

#Preview {
    NavigationStack {
        RentalCreateView(book: .constant(Book()))
            .environmentObject(BookService())
    }
}
