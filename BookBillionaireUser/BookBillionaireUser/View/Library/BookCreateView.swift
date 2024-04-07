//
//  BookCreateView.swift
//  BookBillionaireUser
//
//  Created by Woo Sung jong on 4/4/24.
//

import SwiftUI
import BookBillionaireCore

struct BookCreateView: View {
    @State var book: Book = Book(owenerID: "", title: "", contents: "", authors: [""], thumbnail: "", rentalState: .rentalAvailable)
    @State var rental: Rental = Rental(id: "", bookOwner: "", rentalStartDay: Date(), rentalEndDay: Date())
    
    var body: some View {
        ScrollView {
            VStack {
                BookInfoAddView(book: $book)
                if book.rentalState == .rentalAvailable {
                    RentalPeriodView(rental: $rental)
                    DescriptionView(book: $book)
                }
                Button("완료") {
                    book.title = ""
                    book.authors = [""]
                    book.contents = ""
                    book.thumbnail = ""
                    rental.rentalStartDay = Date()
                    rental.rentalEndDay = Date()
                } 
                .buttonStyle(AccentButtonStyle())
                .padding()
            }
            SpaceBox()
        }
        .navigationTitle("책 등록")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(destination: {
                    
                }, label: {
                    Label("검색하기", systemImage: "magnifyingglass")
                })
            }
        }
    }
}

#Preview {
    NavigationStack {
        BookCreateView()
    }
}

