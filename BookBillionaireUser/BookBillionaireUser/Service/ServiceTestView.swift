//
//  ServiceTestView.swift
//  BookBillionaireUser
//
//  Created by YUJIN JEON on 4/4/24.
//

import SwiftUI
import FirebaseCore
import FirebaseStorage
import BookBillionaireCore

struct ServiceTestView: View {
    @EnvironmentObject var userService: UserService
    @EnvironmentObject var bookService: BookService
    let rentalService = RentalService()
    let imagesRef = Storage.storage().reference().child("images")

    @State var users: [User] = []
    @State var books: [Book] = []
    @State var rentalTime: (Date, Date) = (Date(), Date())
    @State var rental: Rental = Rental()
    var body: some View {
        Text("\(rental.id)")
        Button("함수 실행") {
            Task{
//                rental = await rentalService.getRental(("02701439-1B2D-4CBD-BACA-AA31ADCB6347"))
//                await rentalService.deleteRental(rental)
                
                
            }
        }
    }
}

#Preview {
    ServiceTestView()
        .environmentObject(UserService())
        .environmentObject(BookService())
}
