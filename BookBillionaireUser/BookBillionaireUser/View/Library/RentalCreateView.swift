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
    @State var rental: Rental = Rental(id: UUID().uuidString, bookOwner: "", rentalStartDay: Date(), rentalEndDay: Date(), map: "", latitude: 0.0, longitude: 0.0)
    let rentalService: RentalService = RentalService()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            HStack {
                BookItem(book: book)
                Spacer()
            }
            RentalPeriodView(rental: $rental)
            Button {
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
        RentalCreateView(book: Book(ownerID: "", title: "Test", contents: "", authors: ["Test1"], rentalState: .rentalAvailable))
            .environmentObject(BookService())
    }
}
