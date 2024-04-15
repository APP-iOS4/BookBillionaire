//
//  MessageView.swift
//  BookBillionaireUser
//
//  Created by 최준영 on 4/3/24.
//

import SwiftUI
import Combine
import BookBillionaireCore

struct ChatView: View {
    let room: RoomViewModel
    
    @State var message: Message = Message(message: "", senderId: "", roomId: "", timestamp: Date(), ImageURL: "")
    
    @StateObject private var messageListVM = MessageListViewModel()
    @State private var promiseViewShowing = false
    @State private var messageText: String = ""
    @State private var cancellables: AnyCancellable?
    @State private var plusItemShowing = false
    @State private var isPresentedExitAlert = false
    @Environment(\.presentationMode) var presentationMode
    
    var username: String? = AuthViewModel.shared.currentUser?.displayName
    
    var body: some View {
        VStack {
            Divider()
            
            promiseBanner
                .padding(.vertical, 10)
            
            Divider()
            
            chatBubble
            
            Spacer()
            
            messageTextField
            
            if plusItemShowing {
                ChatPlusItem(message: $message, messageVM: messageListVM)
                    .padding(.bottom, 50)
                    .padding(.top, 30)
            }
        }
        .navigationTitle(room.receiverName)
        .onAppear {
            messageListVM.registerUpdatesForRoom(room: room)
        }
        .navigationBarItems(trailing:
                                exitView
        )
    }
    
    private func sendMessage() {
        let messageVS = Message(message: messageText, senderId: username ?? "", roomId: room.roomId, timestamp: Date())
        
        messageListVM.sendMessage(msg: messageVS) {
            messageText = ""
        }
    }
    
    // MARK: - 상단 약속 잡기 배너
    private var promiseBanner: some View {
        VStack {
            HStack(alignment: .center) {
                Image(systemName: "a.book.closed.ko")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .padding(.leading, 25)
                    .padding(.trailing, 10)
                VStack(alignment: .leading) {
                    Text("패밀리 레스토랑 가자(상)")
                        .font(.headline)
                    Text("신드롬을 일으킨 『가라오케 가자!』. 출간 직후 종합 베스트셀러 1위는 물론, 탄탄한 팬덤이 생길 만큼 화제가 되었던 작품이다. 끔찍한 벌칙이 걸린 가라오케 대회를 위해 의기투합했던 야쿠자 쿄지와 독설 노래 선생 사토미의 뒷이야기를 궁금해하고, 오매불망 기다려왔던 독자들에게 새로운 이야기가 도착했다. ")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .lineLimit(2)
                }
                .padding(.trailing, 25)
                
                Spacer()
                
            }
            .frame(height: 70)
            
            HStack {
                Spacer()
                
                Button("위치 확인") {
                    // 장소 확인하는 버튼
                }
                .padding(8)
                .padding(.horizontal, 10)
                .font(.callout)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.accentColor, lineWidth: 1))
                
                Spacer()
                    .frame(width: 30)
                
                Button("약속 잡기") {
                    // 약속 잡기 뷰로 이동
                    // promiseViewShowing.toggle()
                    //            hideKeyboard()
                    //        } label: {
                    ////            NavigationLink(destination: PromiseConfirmView(user: User, book: <#Book#>)) {
                    ////                Text("약속잡기")
                    //            }
                   
                }
                .padding(8)
                .padding(.horizontal, 10)
                .font(.callout)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.accentColor, lineWidth: 1))
                
                /* // 파란색 배경 버튼
                 .padding(9)
                 .font(.callout)
                 .background(
                 RoundedRectangle(cornerRadius: 15)
                 .foregroundColor(.accentColor))
                 .foregroundStyle(.white)
                 
                 */
                Spacer()
            }
        }
    }
    
    // MARK: - 채팅 메세지 버블
    private var chatBubble: some View {
        ScrollView {
            ScrollViewReader { scrollView in
                VStack {
                    ForEach(messageListVM.messages, id: \.messageId) { message in
                        HStack {
                            if message.username == username {
                                Spacer()
                                ChatBubble(messageText: message.messageText, username: message.username, style: .from, messageVM: message)
                            } else {
                                ChatBubble(messageText: message.messageText, username: message.username, style: .to, messageVM: message)
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
    }
    
    // MARK: - 채팅 입력 텍스트필드
    private var messageTextField: some View {
        HStack {
            Button {
                plusItemShowing.toggle()
                hideKeyboard()
            } label: {
                plusItemShowing ? Image(systemName: "xmark") : Image(systemName: "plus")
            }
            .padding(.horizontal,10)
            
            
            TextField("메세지를 입력하세요.", text: $messageText)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .disableAutocorrection(true)
            
            Button {
                if messageText != "" {
                    sendMessage()
                    messageText = ""
                }
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
    }
    
    // MARK: - 채팅방 나가기 버튼
    private var exitView: some View {
        Button {
            isPresentedExitAlert = true
        } label: {
            Text("나가기")
        }
        .alert("채팅방을 나가시겠습니까", isPresented: $isPresentedExitAlert) {
            Button("취소", role: .cancel) { }
            Button("나가기", role: .destructive) {
                // 채팅방을 삭제하는 메서드
                messageListVM.deleteRoom(roomID: room.roomId) {
                    // 화면 채팅 목록으로 디스미스
                    presentationMode.wrappedValue.dismiss()
                }
                // 해당 채팅방 안의 메세지들을 전체 삭제하는 메서드
                messageListVM.deleteAllMessagesInRoom(roomID: room.roomId) { _,_ in }
            }
        }
    }
}


extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


#Preview {
    ChatView(room: RoomViewModel(room: Room(receiverId: "최준영", lastTimeStamp: Date(), lastMessage: "", users: ["985ZXtyszUYU9RCKYOaPZYALMyn1","f2tWX84q9Igvg2hpQogOhtvffkO2"])))
}
