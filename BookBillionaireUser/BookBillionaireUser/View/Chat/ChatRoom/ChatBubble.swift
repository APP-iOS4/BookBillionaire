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
    let message: Message = Message(id: "", message: "", senderId: "", roomId: "", timestamp: Date(), ImageURL: "")
    
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
                        Circle()
                            .foregroundColor(.accentColor)
                            .frame(width: 40, height: 40)
                            .opacity(0.8)
                        
                        Image(systemName: "figure.arms.open")
                            .padding(8)
                            .foregroundColor(.white)
                    }
                    
                    HStack(alignment: .bottom) {
                        VStack(alignment: .leading) {
                            Text(username)
                                .font(.caption)
                            if messageText == messageText {
                                Text(messageText)
                                    .lineLimit(nil)
                                    .padding(12)
                                    .background(Color.gray)
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
//    ChatBubble(messageText: "안녕하세요! 📖 책 대여 희망합니다!!", username: "최준영", style: .to, message: MessageViewState.init(message: "", roomId: "", username: "", timestamp: Date()))
//}

