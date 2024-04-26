//
//  QnAView.swift
//  BookBillionaireAdmin
//
//  Created by YUJIN JEON on 4/16/24.
//

import SwiftUI

struct QnAView: View {
    var topic: Topic
    @State var qnaService = QnAService()
    @State var title: String = ""
    @State var content: String = ""
    @State var qna: QnA = QnA(title: "", content: "")
    var body: some View {
        VStack{
            HStack{
                    List{
                        ForEach(qnaService.lists) { list in
                            Text(list.title)
                        }
                    }
                VStack{
                    TextField(
                        "제목을 입력해주세요.", text: $title)
                    .textFieldStyle(.roundedBorder)
                    TextEditor(text: .constant("Placeholder"))
                    Button("QnA 등록하기") {
                        qnaService.registerQnA(qna)
                    }
                }
            }
        }
        .navigationTitle(topic.name)
            .padding(50)
            
        
    }
}

#Preview {
    QnAView(topic: Topic(name: "QnA관리", Icon: "doc.questionmark", topicTitle: .qna))
}
