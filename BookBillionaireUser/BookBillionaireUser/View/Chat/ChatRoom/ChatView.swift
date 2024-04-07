//
//  MessageView.swift
//  BookBillionaireUser
//
//  Created by 최준영 on 4/3/24.
//

import SwiftUI
import Combine

struct ChatView: View {
    let room: RoomViewModel
    
    @StateObject private var messageListVM = MessageListViewModel()
    
    @State private var message: String = ""
    @AppStorage("username") private var username = ""
    @State private var cancellables: AnyCancellable?
    
    var body: some View {
        
        VStack {
            ScrollView {
                ScrollViewReader { scrollView in
                    VStack {
                        ForEach(messageListVM.messages, id: \.messageId) { message in
                            HStack {
                                
                                if message.username == username {
                                    Spacer()
                                    ChatBubble(messageText: message.messageText, username: message.username, style: .from)
                                } else {
                                    ChatBubble(messageText: message.messageText, username: message.username, style: .to)
                                    Spacer()
                                }
                            }
                            .padding()
                            .id(message.messageId)
                        }
                    }.onAppear(perform: {
                       cancellables = messageListVM.$messages.sink { messages in
                            if messages.count > 0 {
                                DispatchQueue.main.async {
                                    withAnimation {
                                        scrollView.scrollTo(messages[messages.endIndex - 1].messageId, anchor: .bottom)
                                    }
                                }
                            }
                        }
                    })
                }
            }
            
            Spacer()
            
            HStack {
                TextField("Write message here", text: $message)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button {
                    sendMessage()
                } label: {
                    Image(systemName: "paperplane.fill")
                }
            }
            .padding()
        }
        .navigationTitle(room.name)
        
        .onAppear(perform: {
            messageListVM.registerUpdatesForRoom(room: room)
        })
    }
    
    private func sendMessage() {
        let messageVS = MessageViewState(message: message, roomId: room.roomId, username: username)
        
        messageListVM.sendMessage(msg: messageVS) {
            message = ""
        }
    }
}

#Preview {
    ChatView(room: RoomViewModel(room: Room(name: "최준영", description: "책 대여 신청합니다")))
}
