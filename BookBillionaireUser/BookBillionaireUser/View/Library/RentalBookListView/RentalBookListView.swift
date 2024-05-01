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
    var rentalBooks: [Rental] {
        return rentalService.filterByBorrowerID(userService.currentUser.id)
    }
    
    var body: some View {
        VStack {
            // 빌린도서 목록
            if rentalBooks.isEmpty {
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
                        ForEach(rentalBooks) { rental in
                            if let book = bookService.books.first(where: { $0.id == rental.bookID }) {
                                NavigationLink {
                                    RentalBookDetailView(book: book, rental: rental, user: userService.loadUserByID(book.ownerID))
                                    .toolbar(.hidden, for: .tabBar)
                                } label: {
                                    HStack {
                                        BookItem(book: book)
                                        Text(returnDateText(rental.rentalEndDay))
                                            .font(.subheadline)
                                            .bold()
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.5)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    SpaceBox()
                }
                .refreshable {
                    rentalService.fetchRentals()
                }
            }
        }
        .onAppear {
            rentalService.fetchRentals()
            print("\(rentalBooks)")
        }
    }
    
    // 대여 반납일 함수
    func returnDateText(_ returnDate: Date) -> String {
        let calendar = Calendar.current
        // 현재 날짜 반환
        let now = calendar.startOfDay(for: Date())
        // 대여 반납 날짜 반환
        let returnDay = calendar.startOfDay(for: returnDate)
        // 두 날짜 간의 차이를 일 단위로 계산
        let components = calendar.dateComponents([.day], from: now, to: returnDay)
        let remainingDays = components.day ?? 0
        // 기간에 따른 텍스트 조건
        if remainingDays > 0 {
            return "D-\(remainingDays)"
        } else if remainingDays == 0 {
            return "오늘 반납일입니다"
        } else {
            return "반납일이 \(-remainingDays)일 지났습니다"
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
