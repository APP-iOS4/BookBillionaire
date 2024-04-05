//
//  ServiceTestView.swift
//  BookBillionaireUser
//
//  Created by YUJIN JEON on 4/4/24.
//

import SwiftUI
import BookBillionaireCore

struct ServiceTestView: View {
    let userService: UserService = UserService.shared
    let bookService: BookService = BookService.shared
    let mapService: MapService = MapService.shared
    let rentalService: RentalService = RentalService.shared

    @State var users: [User] = []
    @State var books: [Book] = []
    var body: some View {
        Button("함수 실행") {
            Task{
                await userService.loadUserByID("Eyhr4YQGsATlRDUcc9rYl9PZYk52")
            }
        }
    }
}

#Preview {
    ServiceTestView()
}
