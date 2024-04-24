//
//  ChatView.swift
//  BookBillionaireUser
//
//  Created by 최준영 on 4/3/24.
//

import SwiftUI
import Combine
import BookBillionaireCore

struct ChatView: View {
    let room: RoomViewModel
    
    @StateObject private var messageListVM = ChatViewModel()
    @State var messageModel: Message = Message(message: "", senderName: "", roomId: "", timestamp: Date())
    @State private var promiseViewShowing = false
    @State var messageText: String = ""
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
                .padding(.top, 5)
            
            Spacer()
            
            messageTextField
            
            if plusItemShowing {
                ChatPlusItem(message: $messageModel, messageText: $messageText, messageListVM: messageListVM)
                    .padding(.bottom, 50)
                    .padding(.top, 30)
            }
        }
        .navigationTitle(getUserName())
        .navigationBarItems(trailing:
                                exitView
        )
    }
    
    private func getUserName() -> String {
           guard let currentUser = AuthViewModel.shared.currentUser else {
               return ""
           }

           if currentUser.displayName == room.receiverName {
               return currentUser.displayName ?? ""
           } else {
               return room.receiverName
           }
       }
    
    private func sendMessage() {
        let messageVS = Message(message: messageText, senderName: username ?? "", roomId: room.roomId, timestamp: Date(), imageUrl: messageModel.imageUrl)
        
        messageListVM.sendMessage(msg: messageVS) {
            messageText = ""
        }
    }
    
    // MARK: - 상단 약속 잡기 배너
    private var promiseBanner: some View {
        VStack {
            HStack(alignment: .center) {
                AsyncImage(url: URL(string:
                                        "https://search1.kakaocdn.net/thumb/R120x174.q85/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flbook%2Fimage%2F1103577%3Ftimestamp%3D20221025123259"
                                   )) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 85, height: 100)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.accentColor, lineWidth: 1)
                )
                .padding(.leading, 25)
                .padding(.trailing, 10)
                
                VStack(alignment: .leading) {
                    
                    Text("Clean Code(클린 코드)")
                        .font(.headline)
                        .bold()
                    
                    Text("『Clean Code(클린 코드)』은 오브젝트 멘토(Object Mentor)의 동료들과 힘을 모아 ‘개발하며’ 클린 코드를 만드는 최상의 애자일 기법을 소개하고 있다. 소프트웨어 장인 정신의 가치를 심어 주며 프로그래밍 실력을 높여줄 것이다. 여러분이 노력만 한다면. 어떤 노력이 필요하냐고? 코드를 읽어야 한다. 아주 많은 코드를. 그리고 코드를 읽으면서 그 코드의 무엇이 옳은지, 그른지 생각도 해야 한다. 좀 더 중요하게는 전문가로서 자신이 지니는 가치")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .lineLimit(2)
                    
                    HStack {
                        Button("위치 확인") {
                            // 장소 확인하는 버튼
                        }
                        .padding(7)
                        .padding(.horizontal, 17)
                        .font(.callout)
                        .foregroundColor(Color(UIColor.label))
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.accent, lineWidth: 1.5))
                        
                        Spacer()
                        
                        Button("약속 잡기") {
                            // 약속 잡기 뷰로 이동
                            // promiseViewShowing.toggle()
                            //            hideKeyboard()
                            //        } label: {
                            ////            NavigationLink(destination: PromiseConfirmView(user: User, book: <#Book#>)) {
                            ////                Text("약속잡기")
                            //            }
                            
                        }
                        .padding(7)
                        .padding(.horizontal, 17)
                        .font(.callout)
                        .foregroundColor(Color(UIColor.label))
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.accent, lineWidth: 1.5))
                        
                        Spacer()
                    }
                }
                .padding(.trailing, 16)
                
                Spacer()
                
            }
            .frame(height: 120)
        }
    }
    
    // MARK: - 채팅 메세지 버블
    private var chatBubble: some View {
        ScrollViewReader { scrollView in
            ScrollView {
                if messageListVM.messages.isEmpty {
                    HStack {
                        VStack {
                            Text("서로를 존중하고 배려하는 마음으로 소통해주세요!")
                                .foregroundStyle(.gray)
                            Text("욕설 및 비방을 할 경우 이용 제한 조치를 취할 수 있습니다")
                                .foregroundStyle(.gray)
                                .font(.caption)
                        }
                        .rotationEffect(Angle(degrees: 180))
                        .scaleEffect(x: -1.0, y: 1.0, anchor: .center)
                        .padding(.vertical, 200)
                    }
                } else {
                    LazyVStack {
                        ForEach(messageListVM.messages.indices, id: \.self) { index in
                            let message = messageListVM.messages[index]
                            if index > 0 {
                                let prevMessage = messageListVM.messages[index - 1]
                                if !Calendar.current.isDate(prevMessage.messageTimestamp, inSameDayAs: message.messageTimestamp) {
                                    // 이전 메시지와 현재 메시지의 날짜가 다를 경우 날짜 표시
                                    HStack {
                                        Rectangle()
                                            .fill(Color.gray)
                                            .frame(height: 0.2)
                                        Text(formatDate(message.messageTimestamp))
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                            .frame(maxWidth: .infinity, alignment: .center)
                                            .padding(.vertical, 10)
                                        Rectangle()
                                            .fill(Color.gray)
                                            .frame(height: 0.2)
                                    }
                                }
                            }
                            HStack {
                                if message.username == username {
                                    Spacer()
                                    ChatBubble(messageText: message.messageText, username: message.username, imageUrl: message.imageUrl, style: .from, messageVM: message)
                                } else {
                                    ChatBubble(messageText: message.messageText, username: message.username, imageUrl: message.imageUrl, style: .to, messageVM: message)
                                    Spacer()
                                }
                            }
                            .padding(.horizontal, 15)
                            .id(message.messageId)
                        }
                    }
                    .rotationEffect(Angle(degrees: 180))
                    .scaleEffect(x: -1.0, y: 1.0, anchor: .center)
                    // MARK: - 메세지 스크롤 하단 맞춤
                    .onAppear(perform: {
                        cancellables = messageListVM.$messages.sink { messages in
                            guard messages.count > 0, messageListVM.shouldScrollToBottom else { return }
                            DispatchQueue.main.async {
                                withAnimation {
                                    scrollView.scrollTo(messages.last!.messageId, anchor: .bottom)
                                }
                            }
                        }
                    })
                }
            }
            .rotationEffect(Angle(degrees: 180))
            .scaleEffect(x: -1.0, y: 1.0, anchor: .center)
            .onAppear {
                messageListVM.registerUpdatesForRoom(room: room, pageSize: .max)
                // 일단 임시로 max
                // 채팅방의 채팅을 20개만 먼저 가져오기
                print("최초 채팅 20개 불러오기")
            }
            // messageListVM.loadMoreChat(room: room, pageSize: 20)
            // 추가 20개 불러오기
            // 페이지 네이션 추후 구현하기
        }
    }
    
    // MARK: - 채팅 입력 텍스트필드
    private var messageTextField: some View {
        HStack {
            Image(systemName: plusItemShowing ? "xmark" : "plus")
                .foregroundStyle(.accent)
                .onTapGesture {
                    plusItemShowing.toggle()
                    hideKeyboard()
                }
                .padding(.horizontal, 10)
            
            TextField("메세지를 입력하세요.", text: $messageText)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .disableAutocorrection(true)
                .onChange(of: messageText) { newValue in
                    if newValue.contains("https://firebasestorage") {
                        if let urlString = messageModel.imageUrl?.absoluteString {
                            messageText = urlString
                        }
                        sendMessage()
                        messageText = ""
                    }
                }
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

// MARK: - DateFormatter를 이용하여 날짜 포맷 변환
private func formatDate(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ko_KR")
    dateFormatter.dateFormat = "M월 d일 EEEE"
    return dateFormatter.string(from: date)
}

#Preview {
    ChatView(room: RoomViewModel(room: ChatRoom(receiverName: "최준영", lastTimeStamp: Date(), lastMessage: "", users: ["985ZXtyszUYU9RCKYOaPZYALMyn1","f2tWX84q9Igvg2hpQogOhtvffkO2"])))
}
