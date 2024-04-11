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
    @State private var promiseViewShowing = false
    
    @State private var message: String = ""
    @AppStorage("username") private var username = "최준영2"
    // username 갖다 꽂기 [임시로 최준영 적어놓음]
    @State private var cancellables: AnyCancellable?
    @State private var plusItemShowing = false

    var body: some View {
        VStack {
            ScrollView {
                ScrollViewReader { scrollView in
                    VStack {
                        ForEach(messageListVM.messages, id: \.messageId) { message in
                            HStack {
                                if message.username == username {
                                    Spacer()
                                    ChatBubble(messageText: message.messageText, username: message.username, style: .from, message: Message(vs: MessageViewState(message: "", roomId: "", username: "", timestamp: Date())))
                                } else {
                                    ChatBubble(messageText: message.messageText, username: message.username, style: .to, message: Message(vs: MessageViewState(message: "", roomId: "", username: "", timestamp: Date())))
                                    Spacer()
                                }
                            }
                            .padding(.horizontal, 15)
                            .id(message.messageId)
                        }
                    }
                    // MARK: - 메세지 스크롤 하단 맞춤
                    .onAppear(perform: {
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
            
           // MARK: - 텍스트 필드
            HStack {
                Button {
                    plusItemShowing.toggle()
                    hideKeyboard()
                } label: {
                    plusItemShowing ? Image(systemName: "xmark") : Image(systemName: "plus")
                }
                .padding(.horizontal,10)
                
                
                TextField("메세지를 입력하세요.", text: $message)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .disableAutocorrection(true)
                
                Button {
                    sendMessage()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerSize: CGSize(width: 5, height: 5))
                            .foregroundColor(.accentColor)
                        Image(systemName: "paperplane")
                            .foregroundColor(.white)
                    }
                    .frame(width: 40, height: 40)
                }
            }
            .padding(.bottom, 8)
            .padding(.top, 0)
            .padding(.horizontal)
            .background(Color.white)
            .cornerRadius(50)
            
            
            if plusItemShowing {
                ChatPlusItem()
                    .padding(.bottom, 50)
                    .padding(.top, 30)
            }
        }
        .navigationTitle(room.name)
        
        .onAppear {
            messageListVM.registerUpdatesForRoom(room: room)
        }
        // MARK: - 약속잡기 버튼
//        .navigationBarItems(trailing:
//        Button {
//            promiseViewShowing.toggle()
//            hideKeyboard()
//        } label: {
////            NavigationLink(destination: PromiseConfirmView(user: User, book: <#Book#>)) {
////                Text("약속잡기")
//            }
//        })
    }
    
    private func sendMessage() {
        let messageVS = MessageViewState(message: message, roomId: room.roomId, username: username, timestamp: Date())
        
        messageListVM.sendMessage(msg: messageVS) {
            message = ""
        }
    }
}


extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


#Preview {
    ChatView(room: RoomViewModel(room: Room(name: "최준영", description: "책 대여 신청합니다"/*, users: ["985ZXtyszUYU9RCKYOaPZYALMyn1","f2tWX84q9Igvg2hpQogOhtvffkO2"]*/)))
}
