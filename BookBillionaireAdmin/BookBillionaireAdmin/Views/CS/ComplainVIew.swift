//
//  BlackListView.swift
//  BookBillionaireAdmin
//
//  Created by YUJIN JEON on 4/23/24.
//

import SwiftUI

struct ComplainView: View {
    var topic: Topic
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .navigationTitle(topic.name)
    }
}

#Preview {
    NavigationStack{
        ComplainView(topic: Topic(name: "신고 유저 관리", Icon: "exclamationmark.triangle.fill", topicTitle: .complain))
    }
}
