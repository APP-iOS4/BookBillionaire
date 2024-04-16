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
    let userService: UserService = UserService.shared
    let bookService: BookService = BookService.shared
    let mapService: MapService = MapService.shared
    let rentalService: RentalService = RentalService.shared
    let imagesRef = Storage.storage().reference().child("images")

    @State var users: [User] = []
    @State var books: [Book] = []
    var body: some View {
        Button("함수 실행") {
                books =  bookService.filterByCategory(.best)
            print(books)
        }
        .onAppear{
            bookService.fetchBooks()
            books = bookService.books
            
        }
    }
}

#Preview {
    ServiceTestView()
}
