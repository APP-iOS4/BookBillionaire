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
        GeometryReader { geometry in
            HStack(spacing: 0) {
                Rectangle()
                    .fill(Color.red)
                    .frame(width: geometry.size.width / 3)
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 2 * geometry.size.width / 3)
            }
        }
    }
}


#Preview {
    NavigationStack{
        ComplainView(topic: Topic(name: "신고 유저 관리", Icon: "exclamationmark.triangle.fill", topicTitle: .complain))
    }
}
