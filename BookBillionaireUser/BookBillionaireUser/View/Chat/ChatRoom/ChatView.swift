//
//  ChatView.swift
//  BookBillionaireUser
//
//  Created by 최준영 on 4/3/24.
//

import SwiftUI
import Combine
import BookBillionaireCore
import PhotosUI
import FirebaseStorage

struct ChatView: View {
    let room: RoomViewModel
    let roomVM: ChatListViewModel
    
    @StateObject private var messageListVM = ChatViewModel()
    @State var messageModel: Message = Message(message: "", senderName: "", roomId: "", timestamp: Date())
    @State var messageText: String = ""
    @State private var cancellables: AnyCancellable?
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    
    @State private var isPresentedExitAlert = false
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userService : UserService
    @EnvironmentObject var bookService : BookService
    
    var username: String? = AuthViewModel.shared.currentUser?.displayName
    
    var body: some View {
        VStack {
            
            promiseBanner
                .padding(.vertical, 10)
                .padding(.top, 10)
            
            chatBubble
                .padding(.top, 5)
            
            Spacer()
            
            messageTextField
            
        }
        .navigationTitle(Text(roomName(users: room.room.users)))
        .navigationBarItems(trailing:
                                exitView
        )
    }
    
    private func roomName(users: [String]) -> String {
        for user in users {
            if user != userService.currentUser.id {
                return userService.loadUserByID(user).nickName
            }
        }
        return "사용자 이름없음"
    }
    
    private func getUserName() -> String {
        guard let currentUser = username else {
            return ""
        }
        
        if currentUser == room.receiverName {
            return currentUser
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
        HStack(spacing: 0) {
            NavigationLink(destination: MeetingMapView(book: room.room.book, roomVM: roomVM)) {
                Text("위치확인")
                    .font(.subheadline)
                    .foregroundStyle(.bbfont)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 0).strokeBorder())
            }
            
            NavigationLink(destination: PromiseConfirmView(user: room.room.book.ownerNickname, room: room, roomVM: roomVM, book: room.room.book)) {
                Text("약속잡기")
                    .font(.subheadline)
                    .foregroundStyle(.bbfont)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 0).strokeBorder())
            }
            
            NavigationLink(destination: ComplainView(user: room.room.book.ownerNickname, room: room, roomVM: roomVM, book: room.room.book)) {
                Text("신고하기")
                    .font(.subheadline)
                    .foregroundStyle(.bbfont)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 0).strokeBorder())
            }
        }
        .frame(maxHeight: 20)
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
                        .padding(.vertical, 250)
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
    
    // MARK: - 채팅 입력 텍스트필드 + 사진 보내기 버튼
    private var messageTextField: some View {
        HStack {
            GridRow {
                Button {
                    hideKeyboard()
                } label: {
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        Image(systemName: "photo.fill")
                            .resizable()
                            .frame(width: 27, height: 20)
                            .foregroundStyle(Color.accentColor)
                            .padding(.horizontal, 10)
                    }
                }
                .onChange(of: selectedItem) { _ in
                    Task {
                        if let selectedItem,
                           let data = try? await selectedItem.loadTransferable(type: Data.self) {
                            if let image = UIImage(data: data) {
                                selectedImage = image
                                
                                messageListVM.uploadPhoto(selectedImage: selectedImage) { imageURL in
                                    if let imageURL = imageURL {
                                        print("업로드 이미지 URL 받아오기 성공: \(imageURL) 🎉")
                                        // 메세지 텍스트 필드로 url 전달
                                        messageModel.imageUrl = imageURL
                                        
                                        if let urlString = messageModel.imageUrl?.absoluteString {
                                            messageText = urlString
                                            print("22=============\(String(describing: messageModel.imageUrl))")
                                        }
                                    } else {
                                        // 이미지 업로드에 실패한 경우 또는 다운로드 URL을 가져오는 데 실패한 경우
                                        print("업로드 이미지 URL 다운로드를 실패했습니다 🥲")
                                    }
                                }
                            }
                        }
                        selectedItem = nil
                    }
                }
            }
            
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

//#Preview {
//    ChatView(room: RoomViewModel(room: ChatRoom(receiverName: "최준영", lastTimeStamp: Date(), lastMessage: "", users: ["985ZXtyszUYU9RCKYOaPZYALMyn1","f2tWX84q9Igvg2hpQogOhtvffkO2"], usersUnreadCountInfo: [:])))
//}
