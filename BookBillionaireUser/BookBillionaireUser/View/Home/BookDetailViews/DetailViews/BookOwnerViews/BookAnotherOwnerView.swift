//
//  BookAnotherOwnerView.swift
//  BookBillionaireUser
//
//  Created by 홍승표 on 4/16/24.
//

import SwiftUI
import BookBillionaireCore

struct BookAnotherOwnerView: View {
    let book: Book
    let user: User
    
    var body: some View {
        VStack{
            HStack(alignment: .center) {
                Text("읽고싶은 책인데 대여중이라면?")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.bottom, 5)
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.bottom, 5)
                Spacer()
            }
            
            VStack {
                BookDetailOwnerRowView(book: book, user: user)
                BookDetailOwnerRowView(book: book, user: user)
                BookDetailOwnerRowView(book: book, user: user)
                BookDetailOwnerRowView(book: book, user: user)
            }
        }
    }
}

    #Preview {
        BookAnotherOwnerView(book: Book(ownerID: "", ownerNickname: "", title: "책이름", contents: "줄거리", authors: ["작가"], rentalState: RentalStateType(rawValue: "") ?? .rentalAvailable), user: User(nickName: "닉네임", address: "주소"))
    }
