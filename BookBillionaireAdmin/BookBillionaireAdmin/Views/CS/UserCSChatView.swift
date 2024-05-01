//
//  UserCSChatView.swift
//  BookBillionaireAdmin
//
//  Created by YUJIN JEON on 4/27/24.
//

import SwiftUI
import BookBillionaireCore

struct UserCSChatView: View {
    var topic: Topic
    @State private var result: [User] = []
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                ZStack{
                    Rectangle()
                        .fill(Color.bbBGcolor)
                        .frame(width: geometry.size.width / 3)
                    VStack{
                        UserSearchBar(result: $result)
                            .padding()
                        ForEach(result) { user in
                            HStack{
                                Image(user.image ?? "default")
                                VStack(alignment: .leading) {
                                    Text(user.nickName)
                                    Text(user.id)
                                }
                            }
                        }
                    }
                }
                ZStack{
                    Rectangle()
                        .fill(Color.bbBGcolor)
                        .frame(width: 2 * geometry.size.width / 3)
                }
            }
        }
    }
}

#Preview {
    UserCSChatView(topic: Topic(name: "유저 CS관리", Icon: "ellipsis.message", topicTitle: .chat))
}
