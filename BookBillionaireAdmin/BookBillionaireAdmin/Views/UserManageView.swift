//
//  UserManageView.swift
//  BookBillionaireAdmin
//
//  Created by YUJIN JEON on 4/20/24.
//

import SwiftUI
import BookBillionaireCore

struct UserManageView: View {
    @EnvironmentObject private var userService : UserService
    @State var users: [User] = []
    var topic : Topic
    var body: some View {
        NavigationStack{
            VStack{
                HStack{
                    Button("동기화") {
                    }.buttonStyle(AccentButtonStyle(height: 40))
                        .padding(.leading, 1000)
                }
                
            }
            .navigationTitle(topic.name)
        }
        .task{
            userService.fetchUsers()
        }
        .onReceive(userService.$users, perform: { _ in users = userService.users })
    }
}

#Preview {
    UserManageView(topic: Topic(name: "유저 등록 및 수정", Icon: "person.2.badge.gearshape", topicTitle: .userManage))
        .environmentObject(UserService())
}
