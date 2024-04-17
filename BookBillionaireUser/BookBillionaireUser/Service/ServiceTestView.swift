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
    let rentalService: RentalService = RentalService.shared
    let imagesRef = Storage.storage().reference().child("images")

    @State var users: [User] = []
    @State var books: [Book] = []
    var body: some View {
        Button("함수 실행") {
            Task{
                await userService.loadUsers()
            }
            print("\(userService.loadUserByID("CG8Ilul95OOoFcEEk8LUUNhWSqz1"))")
        }
    }
}

#Preview {
    ServiceTestView()
        .environmentObject(UserService())
        .environmentObject(BookService())
}
