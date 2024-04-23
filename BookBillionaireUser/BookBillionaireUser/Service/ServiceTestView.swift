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
        Text(userService.currentUser.id)
        Button("함수 실행") {
            Task{
                await userService.toggleFavoriteStatus(
bookID: "08E91171-79BE-4A1E-A5CE-561368C9D504")
            }
        }
    }
}

#Preview {
    ServiceTestView()
        .environmentObject(UserService())
        .environmentObject(BookService())
}
