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
                // 추후 컴포넌트로 변경
                Button {
                    book.title = ""
                    book.authors = [""]
                    book.contents = ""
                    book.thumbnail = ""
                    rental.rentalStartDay = Date()
                    rental.rentalEndDay = Date()
                } label: {
                    Text("완료")
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                }
                .background(Color.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .padding()
            }
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

