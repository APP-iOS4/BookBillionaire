//
//  DocUploadView.swift
//  BookBillionaireAdmin
//
//  Created by YUJIN JEON on 4/27/24.
//

import SwiftUI
import BookBillionaireCore

struct HtmlDocUploadView: View {
    @State var fileType: FileType = .termsOfUse
    var topic: Topic
    @State var termsOfUses: [FileTypeHtml] = []
    @State var privatePolicy: [FileTypeHtml] = []
    @State private var isDocumentPickerPresented = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("현재 약관과 개인정보 처리 방침은 .html 파일로 업로드만 지원합니다.")
                .padding(.bottom, 5)
            HStack{
                // 이용약관에 대한 버튼
                VStack{
                    Text("이용약관 리스트").bold()
                    List(termsOfUses) { item in
                        VStack(alignment: .leading) {
                            Text(item.url?.lastPathComponent ?? "파일이름 확인불가").bold()
                            Text(formatDate(item.createAt))
                        }
                    }
                    .background(Color.clear).padding(.vertical).clipShape(RoundedRectangle(cornerRadius: 10))
                    Button("이용약관 업로드") {
                        fileType = .termsOfUse
                        isDocumentPickerPresented = true
                    }
                    .buttonStyle(AccentButtonStyle())
                    .fileImporter(
                        isPresented: $isDocumentPickerPresented,
                        allowedContentTypes: [.html]
                    ) { result in
                        switch result {
                        case .success(let file):
                            print(file)
                            UploadService().fileAccessSecureResource(file: file, subject: fileType)
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                    .navigationTitle(topic.name)
                }
                
                //개인정보 처리방침에 대한 버튼
                VStack{
                    Text("개인정보 처리방침").bold()
                    List(privatePolicy) { item in
                        VStack(alignment: .leading) {
                            Text(item.url?.lastPathComponent ?? "파일이름 확인불가").bold()
                            Text(formatDate(item.createAt))
                        }
                    }.background(Color.clear).padding(.vertical).clipShape(RoundedRectangle(cornerRadius: 10))
                    Button("개인정보 처리방침 업로드") {
                        fileType = .privatePolicy
                        isDocumentPickerPresented = true
                    }
                    .buttonStyle(AccentButtonStyle())
                    .fileImporter(
                        isPresented: $isDocumentPickerPresented,
                        allowedContentTypes: [.html]
                    ) { result in
                        switch result {
                        case .success(let file):
                            print(file)
                            UploadService().fileAccessSecureResource(file: file, subject: fileType)
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
            }
            .onAppear{
                Task {
                    termsOfUses = await HtmlLoadServicee().loadHtml(file: .termsOfUse)
                    privatePolicy = await HtmlLoadServicee().loadHtml(file: .privatePolicy)
                }
            }
            .navigationTitle(topic.name)
        }
        .padding(30)
    }
    // MARK: - DateFormatter를 이용하여 날짜 포맷 변환
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "M월 d일"
        return dateFormatter.string(from: date)
    }
}
