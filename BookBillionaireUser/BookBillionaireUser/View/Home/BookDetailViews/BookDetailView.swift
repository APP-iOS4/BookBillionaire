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
    @State var user: User = User()
    @EnvironmentObject var userService: UserService
    @StateObject var commentViewModel = CommnetViewModel()
    
    //채팅
    @EnvironmentObject var authViewModel: AuthViewModel
    @State var roomListVM: RoomListViewModel = RoomListViewModel()
    @State var roomModel: ChatRoom = ChatRoom(id: "", receiverName: "", lastTimeStamp: Date(), lastMessage: "", users: [])
    @State private var isShowingSheet: Bool = false
    @State private var isFavorite: Bool = false
    @State private var showLoginAlert = false
    @State private var isChatViewPresented = false
    
    @State private var roomId: String? // 생성한 방의 id를 담는 변수
    
    // 렌탈
    let rentalService = RentalService()
    @State var rentalTime: (Date, Date) = (Date(), Date())
    @State var rental: Rental = Rental()
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter
    }
    
    
    var body: some View {
        ScrollView {
            BookDetailImageView(book: book)
            // 찜하기, 설정 버튼
            HStack {
                FavoriteButton(isSaveBook: $isFavorite)
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
                                        // 현재 채팅룸의 아이디 값
                                        
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
                    }
                    
                    .buttonStyle(AccentButtonStyle(height: 40.0, font: .headline))
                    
                    .alert(isPresented: $showLoginAlert) {
                        Alert(title: Text("알림"), message: Text("로그인이 필요합니다."), dismissButton: .default(Text("확인")))
                    }
                    
                    .onAppear {
                        roomListVM.receiverName = user.nickName
                        print("1 \(roomListVM.receiverName)")
                        
                        roomListVM.receiverId = user.id
                        print("2 \(roomListVM.receiverId)")
                    }
                    
                    Spacer()
                    VStack(alignment: .leading) {
                        HStack {
                            Text("책 소유자 : \(user.nickName)")
                            Image(user.image ?? "default")
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: 30, height: 30)
                        }
                        // 대여기간 표시
                        Text("대여기간: \(dateFormatter.string(from: rentalTime.0)) ~ \(dateFormatter.string(from: rentalTime.1))")
                    }
                    .font(.headline)
                    .onAppear {
                        Task {
                            rentalTime = await rentalService.getRentalDay(rental.id)
                        }
                    }
                }
                
                Divider()
                    .padding(.vertical, 10)
                
                // 책 정보 섹션
                BookDetailInfoView(book: book)
                
                Divider()
                    .padding(.vertical, 10)
                // 책 소유자 리스트
                BookAnotherOwnerView(book: book, user: user)
                Divider()
                    .padding(.vertical, 10)
                // 사용자들 후기
                BookDetailReviewView(comments: commentViewModel.comments, user: user)
            }
            .padding(.horizontal)
            .navigationTitle(book.title)
            SpaceBox()
        }
        CreateBookReviewView(user: user, commentViewModel: commentViewModel)
    }
}

#Preview {
    BookDetailView(book: Book(ownerID: "", title: "책이름", contents: "줄거리", authors: ["작가"], rentalState: RentalStateType(rawValue: "") ?? .rentalAvailable), user: User(id: "책유저", nickName: "닉네임", address: "주소"))
}
