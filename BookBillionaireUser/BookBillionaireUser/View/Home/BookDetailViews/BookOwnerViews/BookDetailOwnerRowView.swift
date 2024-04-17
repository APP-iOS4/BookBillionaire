//
//  BookDetailUserListView.swift
//  BookBillionaireUser
//
//  Created by 홍승표 on 4/11/24.
//

import SwiftUI
import BookBillionaireCore

struct BookDetailOwnerRowView: View {
    let book: Book
    let user: User
    
    var body: some View {
        HStack{
            Image(user.image ?? "")
                .resizable()
                .clipShape(Circle())
                .frame(width: 50, height: 50)
            Text(user.nickName).font(.headline)
            Spacer()
            StatusButton(status: book.rentalState)
        }
    }
}

#Preview {
    BookDetailOwnerRowView(book: Book(ownerID: "", title: "", contents: "", authors: [""], rentalState: .rentalAvailable), user: User(id: "아이디", nickName: "닉네임", address: "주소"))
}
