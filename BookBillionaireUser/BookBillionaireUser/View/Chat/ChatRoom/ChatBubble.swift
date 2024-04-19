//
//  ChatBubble.swift
//  BookBillionaireUser
//
//  Created by 최준영 on 4/7/24.
//

import SwiftUI

enum MessageStyle {
    case from
    case to
}

struct ChatBubble: View {
    
    let messageText: String
    let username: String
    let style: MessageStyle
    let messageVM: MessageViewModel
    let message: Message = Message(id: "", message: "", senderName: "", roomId: "", timestamp: Date(), ImageURL: "")
    
    var body: some View {
        VStack(alignment: style == .from ? .trailing : .leading) {
            if style == .from {
                HStack(alignment: .bottom) {
                    Text("\(messageVM.formatTimestamp(messageVM.messageTimestamp))")
                        .font(.caption2)
                        .foregroundColor(.gray)
                    if messageText == messageText {
                        Text(messageText)
                            .lineLimit(nil)
                            .padding(12)
                            .background(Color.yellow)
                            .cornerRadius(15)
                            .foregroundColor(.black)
                    } else {
                        PhotoSharedItem(message: message)
                            .cornerRadius(15)
                    }
                }
                .frame(maxWidth: 350, alignment: .trailing)
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
                            if messageText == messageText {
                                Text(messageText)
                                    .lineLimit(nil)
                                    .padding(12)
                                    .background(Color.blue.opacity(0.6))
                                    .foregroundStyle(.white)
                                    .cornerRadius(15)
                            } else {
                                PhotoSharedItem(message: message)
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
}


//#Preview {
//    ChatBubble(messageText: "안녕하세요! 📖 책 대여 희망합니다!!", username: "최준영", style: .to, messageVM: MessageViewState.init(message: "", roomId: "", username: "", timestamp: Date()))
//}

