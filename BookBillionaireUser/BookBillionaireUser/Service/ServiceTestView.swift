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

    let imagesRef = Storage.storage().reference().child("images")
    let rentalService = RentalService()

    @State var users: [User] = []
    @State var books: [Book] = []
    @State var rentalTime: (Date, Date) = (Date(), Date())
    @State var rental: Rental = Rental()
    
    var body: some View {
        Button("함수 실행") {
            Task{
                rental = await rentalService.getRental("0435FF97-97DD-40E3-9FB1-90D0947551B4")
                rentalTime = await rentalService.getRentalDay("0435FF97-97DD-40E3-9FB1-90D0947551B4")
            }
        }
    }
}

#Preview {
    ServiceTestView()
        .environmentObject(UserService())
        .environmentObject(BookService())
}
