//
//  UserListView.swift
//  BookBillionaireAdmin
//
//  Created by YUJIN JEON on 4/23/24.
//

import SwiftUI

struct UserListView: View {
    @EnvironmentObject var userService: UserService
    var topic: Topic
    var body: some View {
        VStack{
            ScrollView{
                ForEach(userService.users) { user in
                    UserRow(user: user)
                }
                .padding(10)
            }
        }
        .navigationTitle(topic.name)
    }
}

#Preview {
    NavigationStack{
        UserListView(topic: Topic(name: "유저 목록확인", Icon: "person.3.fill", topicTitle: .user))
            .environmentObject(UserService())
    }
}
