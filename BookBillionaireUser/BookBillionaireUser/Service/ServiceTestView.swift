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
    @State var users: [User] = []
    var body: some View {
        Button("함수 실행") {
            Task{
                await userService.setBooksToUser(
                    userID: "Eyhr4YQGsATlRDUcc9rYl9PZYk52",
                    book:"8EFFD572-5B4E-41CD-B3DA-0BA40665669F"
                )
            }
        }
    }
    
}

#Preview {
    ServiceTestView()
}
