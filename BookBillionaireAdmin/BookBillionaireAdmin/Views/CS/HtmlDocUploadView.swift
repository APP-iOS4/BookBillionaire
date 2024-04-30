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
    @State private var isDocumentPickerPresented = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("현재 약관과 개인정보 처리 방침은 .html 파일로 업로드만 지원합니다.")
            HStack{
                // 이용약관에 대한 버튼
                VStack{
                    List{
                        
                    }.listStyle(.grouped)
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
                            var uploadService = UploadService()
                            UploadService().fileAccessSecureResource(file: file, subject: fileType)
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                    .navigationTitle(topic.name)
                }
                
                //개인정보 처리방침에 대한 버튼
                VStack{
                    List{}.listStyle(.grouped)
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
            
            .navigationTitle(topic.name)
        }
        .padding(30)
    }
}
