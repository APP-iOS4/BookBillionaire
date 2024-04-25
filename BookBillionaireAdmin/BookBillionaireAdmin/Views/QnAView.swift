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

    var body: some View {
        VStack{
            HStack{
                Form {
                    Text("QnA 이미지 업로드")
                        .font(.title2).bold()
                    ZStack{
                        RoundedRectangle(cornerRadius: 5.0)
                            .stroke(Color.accentColor, lineWidth: 1)
                        Image(systemName: "plus")
                    }
                }.formStyle(.columns)
                    .padding(80)
                Form {
                    Text("QnA 생성")
                        .font(.title2).bold()
                    HStack{
                        TextField("제목을 입력하세요.", text: $title)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.accentColor, lineWidth: 1)
                            )
                    }
                    .padding(.bottom)
                    TextEditor(text: $content)
                        .background(Color.primary.colorInvert())
                        .frame(minHeight: 300, maxHeight: 400)
                        .cornerRadius(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.accentColor, lineWidth: 1)
                                .frame(minHeight: 300, maxHeight: 400)
                                .scrollContentBackground(.hidden)
                            
                        )
                        .padding(.bottom)
                    Button("QnA 생성") {
                        if title != "" {
                            let qna = QnA(title: title, content: content)
                            qnaService.registerQnA(qna)
                            title = ""
                            content = ""
                        }
                    }.buttonStyle(AccentButtonStyle())
                }
                .formStyle(.columns)
                .padding(30)
            }
            
        }
        .navigationTitle(topic.name)
        .padding()
    }
}


#Preview {
    QnAView(topic: Topic(name: "QnA관리", Icon: "doc.questionmark", topicTitle: .qna))
}
