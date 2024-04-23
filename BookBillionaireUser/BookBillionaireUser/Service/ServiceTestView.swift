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
    let mapService: MapService = MapService.shared
    @EnvironmentObject var userService: UserService
    @EnvironmentObject var bookService: BookService

    let imagesRef = Storage.storage().reference().child("images")
    let rentalService = RentalService()

    @State var users: [User] = []
    @State var books: [Book] = []
    @State var rentalTime: (Date, Date) = (Date(), Date())
    @State var rental: Rental = Rental()
    @State var isFavorite: Bool = false
    var body: some View {
        Button("함수 실행") {
            Task{
            }
        }
    }
}

#Preview {
    ServiceTestView()
        .environmentObject(UserService())
        .environmentObject(BookService())
}
