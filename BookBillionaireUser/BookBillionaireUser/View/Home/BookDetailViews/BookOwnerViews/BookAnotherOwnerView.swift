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
        // 책 목록
        VStack{
            HStack(alignment: .center) {
                Text("📖 읽고싶은 책인데 대여중이라면?")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.bottom, 5)
                Spacer()
//                Button {
//                    // 동일 책 소유자 유저 리스트 더 나올거 sheet
//                } label: {
//                    Text("더 보기")
//                        .font(.caption)
//                    Image(systemName: "chevron.right")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 4)
//                }
            }
            
            VStack {
                // 각각 디테일 뷰 연결
                BookDetailOwnerRowView(book: book, user: user)
                BookDetailOwnerRowView(book: book, user: user)
                BookDetailOwnerRowView(book: book, user: user)
                BookDetailOwnerRowView(book: book, user: user)
            }
        }
    }
}

    #Preview {
        BookAnotherOwnerView(book: Book(ownerID: "", title: "책이름", contents: "줄거리", authors: ["작가"], rentalState: RentalStateType(rawValue: "") ?? .rentalAvailable), user: User(id: "책유저", nickName: "닉네임", address: "주소"))
    }
