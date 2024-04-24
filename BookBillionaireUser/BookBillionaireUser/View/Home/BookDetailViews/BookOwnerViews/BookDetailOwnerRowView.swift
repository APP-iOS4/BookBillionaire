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
            if let url = URL(string: user.image ?? "") {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 40, height: 40)
                } placeholder: {
                    ProgressView()
                }
            } else {
                Image("default")
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 40, height: 40)
            }
            Text(user.nickName).font(.headline)
            Spacer()
            StatusButton(status: book.rentalState)
        }
    }
}

#Preview {
    BookDetailOwnerRowView(book: Book(ownerID: "", ownerNickname:"", title: "", contents: "", authors: [""], rentalState: .rentalAvailable), user: User(nickName: "닉네임", address: "주소"))
}
