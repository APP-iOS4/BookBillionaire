//
//  BlackListView.swift
//  BookBillionaireAdmin
//
//  Created by YUJIN JEON on 4/23/24.
//

import SwiftUI

struct BlackListView: View {
    var topic: Topic
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    NavigationStack{
        BlackListView(topic: Topic(name: "신고 유저 관리", Icon: "exclamationmark.triangle.fill", topicTitle: .blackList))
    }
}
