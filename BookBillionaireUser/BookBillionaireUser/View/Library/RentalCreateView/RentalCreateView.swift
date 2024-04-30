//
//  RentalCreateView.swift
//  BookBillionaireUser
//
//  Created by Woo Sung jong on 4/17/24.
//

import SwiftUI
import BookBillionaireCore

struct RentalCreateView: View {
    @State var book: Book
    @State var rental: Rental = Rental()
    @EnvironmentObject var bookService: BookService
    @EnvironmentObject var rentalService: RentalService
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            HStack {
                BookItem(book: book)
                Spacer()
            }
            .padding()
            RentalInfoView(rental: $rental)
            Button {
                registerRental()
                updateBook()
                dismiss()
            } label: {
                Text("완료")
            }
            .buttonStyle(AccentButtonStyle())
            .padding()
            Spacer()
        }
        .onAppear {
            if !book.rental.isEmpty {
                getRental()
            }
        }
        .navigationTitle("대여 정보 등록")
        .navigationBarTitleDisplayMode(.inline)
    }
    // 렌탈 등록하기
    private func registerRental() {
        if book.rental == "" {
            rental.bookOwner = book.ownerID
            rental.bookID = book.id
            book.rental = rental.id
            _ = rentalService.registerRental(rental)
        } else {
            updateRental()
        }
    }
    // 렌탈 업데이트
    private func updateRental() {
        Task {
            await rentalService.updateRental(rental)
        }
    }
    // 렌탈 가져오기
    private func getRental() {
        Task {
            rental = await rentalService.getRental(book.rental)
        }
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
