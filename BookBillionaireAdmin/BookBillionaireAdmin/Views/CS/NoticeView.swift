//
//  NoticeView.swift
//  BookBillionaireAdmin
//
//  Created by YUJIN JEON on 4/24/24.
//

import SwiftUI

struct NoticeView: View {
    var topic: Topic
    @State var noticeService = NoticeService()
    @State var title: String = ""
    @State var content: String = ""
    @State var notice: Notice = Notice(title: "", content: "")
    
    var body: some View {
        VStack{
            HStack{
                List{
//                    ForEach(noticeService.lists) { list in
//
//
//                    }
                }
            }
        }
        .navigationTitle(topic.name)
            .padding(50)
            
        
    }
}
#Preview {
    NoticeView(topic: Topic(name: "공지사항관리", Icon: "note.text", topicTitle: .notice))
}
