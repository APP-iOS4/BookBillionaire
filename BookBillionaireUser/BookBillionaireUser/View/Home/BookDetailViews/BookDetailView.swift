//
//  BookDetailView.swift
//  BookBillionaireUser
//
//  Created by 홍승표 on 4/3/24.
//


import SwiftUI
import BookBillionaireCore

struct BookDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    let book: Book
    @State var user: User = User()
    @EnvironmentObject var userService: UserService
    @StateObject var commentViewModel = CommnetViewModel()
    
    //채팅
    @EnvironmentObject var authViewModel: AuthViewModel
    @State var roomListVM: ChatListViewModel = ChatListViewModel()
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
                .frame(height: 200)
            
            // 대여신청 섹션
            VStack(alignment: .leading) {
                HStack(alignment: .center){
                    Text(book.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .lineLimit(2)
                        .minimumScaleFactor(0.5)
                    
                    // 로그인 해야 좋아요 가능
                    if authViewModel.state == .loggedIn {
                        FavoriteButton(isSaveBook: $isFavorite)
                            .onTapGesture {
                                Task {
                                    if let loadUsersFavorite = await userService.toggleFavoriteStatus(bookID: book.id) {
                                        isFavorite = loadUsersFavorite
                                    }
                                }
                            }
                            .onAppear {
                                // 뷰가 나타날 때마다 즐겨찾기 상태 업데이트
                                Task {
                                    isFavorite = await userService.checkFavoriteStatus(bookID: book.id)
                                }
                            }
                    }
                    
                    Spacer()
                    
                    // 대여 상태
                    StatusButton(status: book.rentalState)
                }
                
                // 채팅하기 버튼 채팅방으로 이동
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
                    // 책 소유자 / 렌탈 기간
                    VStack(alignment: .leading) {
                        HStack {
                            Text("책 소유자 : \(user.nickName)")
                            if let url = URL(string: user.image ?? "") {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .clipShape(Circle())
                                        .frame(width: 30, height: 30)
                                } placeholder: {
                                    ProgressView()
                                }
                            } else {
                                Image("default")
                                    .resizable()
                                    .clipShape(Circle())
                                    .frame(width: 30, height: 30)
                            }
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
                .toolbar {  // 찜하기, 설정 버튼
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack {
                            Menu {
                                ShareLink(item: URL(string: "https://github.com/tv1039")!) {
                                    Label("게시물 공유하기", systemImage: "square.and.arrow.up")
                                }
                                
                                // 로그인 해야 신고 가능
                                if authViewModel.state == .loggedIn {
                                    Button(role: .destructive) {
                                        isShowingSheet = true
                                    } label: {
                                        Label("신고하기", systemImage: "exclamationmark.triangle")
                                    }
                                }
                                
                            } label: {
                                Image(systemName: "ellipsis")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(.gray.opacity(0.3))
                                    .rotationEffect(.degrees(90))
                            }
                        } // 신고시트
                        .sheet(isPresented: $isShowingSheet) {
                            BottomSheet(isShowingSheet: $isShowingSheet)
                                .presentationDetents([.fraction(0.8), .large])
                        }
                    }
                }
        }
        // 추후 리뷰 쓰는곳 옮김
        //        CreateBookReviewView(user: user, commentViewModel: commentViewModel)
    }
    
}

#Preview {
    NavigationView{
        BookDetailView(book: Book(ownerID: "", ownerNickname: "", title: "책 제목", contents: "줄거리", authors: ["작가"], rentalState: RentalStateType(rawValue: "") ?? .rentalAvailable), user: User(nickName: "닉네임", address: "주소"))
            .navigationBarTitleDisplayMode(.inline)
    }
    .environmentObject(AuthViewModel())
    .environmentObject(UserService())
}
