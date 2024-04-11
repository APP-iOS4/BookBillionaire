//
//  BookDetailUserListView.swift
//  BookBillionaireUser
//
//  Created by 홍승표 on 4/11/24.
//

import SwiftUI
import BookBillionaireCore

struct BookDetailUserListView: View {
    let user: User
    
    var body: some View {
        HStack{
            Image(user.image ?? "")
                .resizable()
                .clipShape(Circle())
                .frame(width: 50, height: 50)
            Text(user.nickName).font(.headline)
            Spacer()
            // 렌탈 부분 설정 후 상태 버튼으로 변경
            Button {
                Void()
            } label: {
                Text("대여 가능")
            }
        }
    }
}

#Preview {
    BookDetailUserListView(user: User(id: "아이디", nickName: "닉네임", address: "주소"))
}
