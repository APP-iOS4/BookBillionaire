//
//  QnAView.swift
//  BookBillionaireAdmin
//
//  Created by YUJIN JEON on 4/16/24.
//

import SwiftUI
import PhotosUI
import FirebaseStorage

struct QnAView: View {
    var topic: Topic
    @State var qnaService = QnAService()
    @State var title: String = ""
    @State var content: String = ""
    @State private var selectedImage: UIImage?
    @State private var selectedItem: PhotosPickerItem?
    @State private var isShowingPhotosPicker: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Form {
                    Text("QnA 이미지 업로드")
                        .font(.title2).bold()
                    ZStack {
                        RoundedRectangle(cornerRadius: 5.0)
                            .stroke(Color.accentColor, lineWidth: 1)
                        
                        Button {
                            isShowingPhotosPicker.toggle()
                        } label: {
                            if let image = selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                            } else {
                                Image(systemName: "plus")
                            }
                        }
                    }
                }
                .formStyle(.columns)
                .padding(80)
                Form {
                    Text("QnA 생성")
                        .font(.title2).bold()
                    HStack {
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
                        uploadPhoto()
                    }
                    .buttonStyle(AccentButtonStyle())
                }
                .formStyle(.columns)
                .padding(30)
            }
            
        }
        .photosPicker(isPresented: $isShowingPhotosPicker, selection: $selectedItem, matching: .images)
        .onChange(of: selectedItem) { _ in
            Task {
                if let selectedItem,
                   let data = try? await selectedItem.loadTransferable(type: Data.self) {
                    if let image = UIImage(data: data) {
                        selectedImage = image
                    }
                }
            }
        }
        .navigationTitle(topic.name)
        .padding()
    }
    
    private func uploadPhoto() {
        guard let selectedItem = selectedItem else {
            return
        }
        Task {
            if let data = try? await selectedItem.loadTransferable(type: Data.self) {
                let storageRef = Storage.storage().reference()
                let path = "QnA/.jpg"
                let fileRef = storageRef.child(path)
                let _ = fileRef.putData(data, metadata: nil) { metadata, error in
                    if error == nil && metadata != nil {
                        // Handle successful upload
                    } else if let error = error {
                        // Handle unsuccessful upload
                        print("Error uploading image: \(error)")
                    }
                }
            }
        }
    }
}


#Preview {
    QnAView(topic: Topic(name: "QnA관리", Icon: "doc.questionmark", topicTitle: .qna))
}
