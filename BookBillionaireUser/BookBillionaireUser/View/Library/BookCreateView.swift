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
    @State var book: Book = Book(owenerID: UUID().uuidString, title: "", contents: "", authors: [""], thumbnail: "", rentalState: .rentalAvailable)
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
                    book.id = UUID().uuidString
                    bookService.registerBook(book)
                    resetBook()
                    dismiss()
                }
                .buttonStyle(AccentButtonStyle())
                .disabled(book.title.isEmpty || book.contents.isEmpty || book.authors.isEmpty)
                .padding()
            }
            SpaceBox()
        }
        .sheet(isPresented: $isShowingSheet) {
            APISearchView()
        }
        .navigationTitle("책 등록")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isShowingSheet.toggle()
                } label: {
                    Label("검색하기", systemImage: "magnifyingglass")
                }
            }
        }
    }
    
    private func resetBook() {
        book = Book(owenerID: UUID().uuidString, title: "", contents: "", authors: [""], thumbnail: "", rentalState: .rentalAvailable)
    }
}

#Preview {
    NavigationStack {
        BookCreateView()
    }
}

