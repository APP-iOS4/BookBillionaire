//
//  BookDetailView.swift
//  BookBillionaireUser
//
//  Created by 홍승표 on 4/3/24.
//

import SwiftUI
import BookBillionaireCore

struct BookDetailView: View {
    let book: Book
    let user: User
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @State var roomListVM: RoomListViewModel = RoomListViewModel()
    @State var roomModel: ChatRoom = ChatRoom(id: "", receiverName: "", lastTimeStamp: Date(), lastMessage: "", users: [])
    
    @State private var isShowingSheet: Bool = false
    @State private var isFavorite: Bool = false
    @State private var showLoginAlert = false
    @State private var isChatViewPresented = false
    
    @State private var roomId: String? // 생성한 방의 id를 담는 변수
    
    var body: some View {
        ScrollView {
            BookDetailImageView(book: book)
            // 찜하기, 설정 버튼
            HStack {
                // FavoriteButton(isSaveBook: $isFavorite)
                Spacer()
                Menu {
                    ShareLink(item: URL(string: "https://github.com/tv1039")!) {
                        Label("게시물 공유하기", systemImage: "square.and.arrow.up")
                    }
                    
                    Button(role: .destructive) {
                        isShowingSheet = true
                    } label: {
                        Label("신고하기", systemImage: "exclamationmark.triangle")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30)
                        .foregroundStyle(.gray.opacity(0.3))
                }
            }
            .offset(y: -95)
            .padding(.horizontal, 15)
            // 신고 시트
            .sheet(isPresented: $isShowingSheet) {
                BottomSheet(isShowingSheet: $isShowingSheet)
                    .presentationDetents([.fraction(0.8), .large])
            }
            // 대여신청 섹션
            VStack(alignment: .leading) {
                Rectangle()
                    .frame(height: 100)
                    .foregroundStyle(.clear)
                Spacer()
                HStack{
                    Text(book.title)
                        .font(.title)
                        .fontWeight(.bold)
                    // 대여 상태
                    StatusButton(status: book.rentalState)
                }
                
                VStack(alignment: .leading) {
                    
                    HStack {
                        Button {
                            switch authViewModel.state {
                            case .loggedIn:
                                roomListVM.createRoom { newRoomId in
                                    if let newRoomId = newRoomId {
                                        // 채팅방이 성공적으로 생성되었을 때의 처리
                                        print("성공적으로 방을 생성했습니다. 방 ID: \(newRoomId)")
                                        self.roomId = newRoomId
                                        isChatViewPresented.toggle()
                                    } else {
                                        print("방을 생성하는 데 실패했습니다.")
                                    }
                                }
                            case .loggedOut:
                                showLoginAlert = true
                            }
                        } label: {
                            Text("채팅하기")
                        }
                        .background(
                            NavigationLink(destination: ChatListView(), isActive: $isChatViewPresented) {
                                EmptyView()
                            }
                                .hidden()
                        )
//                        .navigationDestination(isPresented: $isChatViewPresented) {
//                            ChatListView()
//                        }
                        
                        .buttonStyle(AccentButtonStyle(height: 40.0, font: .headline))
                        
                        .alert(isPresented: $showLoginAlert) {
                            Alert(title: Text("알림"), message: Text("로그인이 필요합니다."), dismissButton: .default(Text("확인")))}
                        
                        .onAppear {
                            roomListVM.receiverName = user.nickName
                            print("1 \(roomListVM.receiverName)")
                            
                            roomListVM.receiverId = user.id
                            print("2 \(roomListVM.receiverId)")
                        }
                    }
                }
                
                
                Spacer()
                
                HStack {
                    Text("책 소유자 : \(user.nickName)")
                    Image(user.image ?? "default")
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 30, height: 30)
                }
            }
            Divider()
                .padding(.vertical, 10)
            
            // 책 정보 섹션
            VStack(alignment: .leading){
                Text("작품소개")
                    .font(.subheadline)
                    .fontWeight(.bold)
                Text(book.contents)
                    .font(.system(size: 13))
                
                HStack{
                    if book.authors.isEmpty {
                        Text("저자를 찾을 수 없어요.")
                    } else {
                        ForEach(book.authors, id: \.self) { author in
                            Text(author)
                        }
                    }
                    Divider()
                    ForEach(book.translators ?? ["번역자"], id: \.self) { translator in Text("번역:\(translator)")
                    }
                    Spacer()
                    Text(book.bookCategory?.rawValue ?? "카테고리")
                }
                .font(.caption)
            }
            
            Divider()
                .padding(.vertical, 10)
            
            Divider()
                .padding(.vertical, 10)
        }
        .padding(.horizontal)
        .navigationTitle(book.title)
        SpaceBox()
    }
}




#Preview {
    BookDetailView(book: Book(owenerID: "", title: "책이름", contents: "줄거리", authors: ["작가"], rentalState: RentalStateType(rawValue: "") ?? .rentalAvailable), user: User(id: "책유저", nickName: "닉네임", address: "주소"))
}
