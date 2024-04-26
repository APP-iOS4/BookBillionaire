//
//  RentalBookListView.swift
//  BookBillionaireUser
//
//  Created by Woo Sung jong on 4/3/24.
//

import SwiftUI
import BookBillionaireCore

struct RentalBookListView: View {
    @EnvironmentObject var userService: UserService
    @EnvironmentObject var rentalService: RentalService
    @EnvironmentObject var bookService: BookService
    var myRentals: [Rental] {
        return rentalService.filterByBorrowerID(userService.currentUser.id)
    }
    
    var body: some View {
        VStack {
            // 빌린도서 목록
            if myRentals.isEmpty {
                VStack(spacing: 10) {
                    Spacer()
                    Circle()
                        .stroke(lineWidth: 3)
                        .overlay {
                            Image(systemName: "book")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(20)
                        }
                        .frame(width: 70, height: 70)
                    
                    Text("대여중인 도서가 없습니다.")
                    Text("대여가 완료되면 여기에 표시됩니다.")
                    Spacer()
                }
                .font(.title3)
                .fontWeight(.medium)
                .foregroundStyle(.gray)
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach(myRentals) { rental in
                            if let book = bookService.books.first(where: { $0.id == rental.bookID }) {
                                NavigationLink {
                                    RentalBookDetailView(book: book, rental: rental)
                                } label: {
                                    BookItem(book: book)
                                }
                            }
                        }
                    }
                    .padding()
                    SpaceBox()
                }
            }
        }
        .onAppear {
            print("\(myRentals)")
        }
    }
}


#Preview {
    NavigationStack {
        RentalBookListView()
            .environmentObject(UserService())
            .environmentObject(RentalService())
            .environmentObject(BookService())
    }
}
