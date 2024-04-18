//
//  ChatBubble.swift
//  BookBillionaireUser
//
//  Created by 최준영 on 4/7/24.
//

import SwiftUI
import FirebaseStorage

enum MessageStyle {
    case from
    case to
}

struct ChatBubble: View {
    
    let messageText: String
    let username: String
    let style: MessageStyle
    let messageVM: MessageViewModel
    let message: Message = Message(id: "", message: "", senderName: "", roomId: "", timestamp: Date())
    @State private var imageUrl: URL?
    var chatImageURL: URL?
    
    var body: some View {
        VStack(alignment: style == .from ? .trailing : .leading) {
            if style == .from {
                HStack(alignment: .bottom) {
                    Text("\(messageVM.formatTimestamp(messageVM.messageTimestamp))")
                        .font(.caption2)
                        .foregroundColor(.gray)
                    if messageText.hasPrefix("https://firebasestorage") {
                        if let url = imageUrl {
                            AsyncImage(url: url) { image in
                                image.resizable()
                                    .frame(width: 100, height: 140)
                                    .cornerRadius(10)
                            } placeholder: {
                                ProgressView()
                            }
                        } else {
                            Image("default")
                                .resizable()
                                .frame(width: 100, height: 140)
                                .cornerRadius(10)
                        }
                    } else {
                        Text(messageText)
                            .lineLimit(nil)
                            .padding(12)
                            .background(Color.yellow)
                            .cornerRadius(15)
                            .foregroundColor(.black)
                    }
                }
                .frame(maxWidth: 350, alignment: .trailing)
                .onAppear {
                    // 앞글자에 따라 imageURL에 할당하는 조건
                    if messageText.hasPrefix("https://firebasestorage") {
                        imageUrl = URL(string: messageText)
                    } else {
                        // Firebase Storage 경로
                        let storageRef = Storage.storage().reference(withPath: messageText)
                        storageRef.downloadURL { (url, error) in
                            if let error = error {
                                print("Error getting download URL: \(error)")
                            } else if let url = url {
                                imageUrl = url
                            }
                        }
                    }
                }
            } else {
                
                HStack(alignment: .top) {
                    ZStack {
                        //[임시] 상대방 프로필 사진 불러오기
                        Image("defaultUser")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                    }
                    .padding(.top, 5)
                    
                    HStack(alignment: .bottom) {
                        VStack(alignment: .leading) {
                            Text(username)
                                .font(.caption)

                            if messageText.hasPrefix("https://firebasestorage") {
                                if let url = imageUrl {
                                    AsyncImage(url: url) { image in
                                        image.resizable()
                                            .frame(width: 100, height: 140)
                                            .cornerRadius(10)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                } else {
                                    Image("default")
                                        .resizable()
                                        .frame(width: 100, height: 140)
                                        .cornerRadius(10)
                                }
                            } else {
                                Text(messageText)
                                    .lineLimit(nil)
                                    .padding(12)
                                    .background(Color.blue.opacity(0.6))
                                    .foregroundStyle(.white)
                                    .cornerRadius(15)
                            }
                        }
                        
                        Text("\(messageVM.formatTimestamp(messageVM.messageTimestamp))")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
                .frame(maxWidth: 350, alignment: .leading)
            }
        }
    }
    // 1. 일단 이미지 파일을 파이어 스토어에 올린다 (성공)
    // 2. 올린 이미지 파일의 주소를 받아온다. (성공)
    //    (uploadPhoto 메서드로 받아옴)
    // 3. 주소를 사용해서 채팅창에 띄워준다. (프로그래스만 나옴.... 하) <-해결함 ㅋㄷ
    // 4. URL 주소로 변환해서 잘 받아왔음
    // 5. 이제 함수 뷰모델로 빼고 해당 뷰에서 꺼내서 쓰는 구조로 바꾸기
    
    
}


//#Preview {
//    ChatBubble(messageText: "안녕하세요! 📖 책 대여 희망합니다!!", username: "최준영", style: .to, message: MessageViewState.init(message: "", roomId: "", username: "", timestamp: Date()))
//}

