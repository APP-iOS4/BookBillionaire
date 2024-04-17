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
    let userService = UserService.shared
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State var user: User = User()
    @State var roomListVM: RoomListViewModel = RoomListViewModel()
    
    @State var roomModel: ChatRoom = ChatRoom(id: "", receiverName: "", lastTimeStamp: Date(), lastMessage: "", users: [])
    
    @State private var showLoginAlert = false
    @State private var createdRoomId: String?
    @State var isShowingAlert: Bool = false
    @State var isShowingSheet: Bool = false
    
    var body: some View {
        ZStack {
            //Alert
            if isShowingAlert {
                CustomAlert(alertType: .hidePost, isShowingDefualtAlert: $isShowingAlert)
                    .zIndex(1)
            }
            
            // 정보란
            VStack(alignment: .leading) {
                Rectangle()
                    .frame(height: 100)
                    .foregroundStyle(.clear)
                Spacer()
                
                HStack{
                    Text(book.title)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    StatusButton(status: book.rentalState)
                }
                
                HStack {
                    Button {
                        switch authViewModel.state {
                        case .loggedIn:
                            
                            // 메세지 보내기를 클릭했을때
                            // 생성된 room id 에 해당하는 방으로 뷰가 이동되어야 함
                            
                            roomListVM.createRoom(completion: { })
                            //일단 임시로 ChatListView로 이동하자
                            
                            //roomListVM.getCreatedRoomID(completion: {_ in })
                            
                            // 지금 생성된 방의 id를 찾아서 그 방으로 화면 이동을 해야하는데 어떻게 하지
                            // 생성된 방의 id를 변수에 담는다
                            // 그 아이디를 확인해서 해당하는 방으로 이동하는 메서드를 만든다
                            
                        case .loggedOut:
                            showLoginAlert = true
                        }
                    } label: {
                        Text("메세지 보내기")
                    }
                    
                    .buttonStyle(WhiteButtonStyle(height: 40.0, font: .headline))
                    .alert(isPresented: $showLoginAlert) {
                        Alert(title: Text("알림"), message: Text("로그인이 필요합니다."), dismissButton: .default(Text("확인")))
                    }
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Text("대여 신청")
                    }
                    .buttonStyle(AccentButtonStyle(height: 40.0, font: .headline))
                    
                    .onAppear {
                        roomListVM.receiverName = user.nickName
                        print("1 \(roomListVM.receiverName)")
                        
                        roomListVM.receiverId = user.id
                        print("2 \(roomListVM.receiverId)")
                    }
                }
                
                HStack {
                    // 설정 버튼
                    Menu {
                        Button {
                            isShowingAlert.toggle()
                        } label: {
                            Label("게시물 보관하기", systemImage: "square.and.arrow.down")
                        }
                        
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
                            .frame(width: 20)
                            .foregroundStyle(.gray.opacity(0.5))
                    }
                }
                .offset(x: 170, y: -90)
                // 신고 시트
                .sheet(isPresented: $isShowingSheet) {
                    BottomSheet(isShowingSheet: $isShowingSheet)
                        .presentationDetents([.fraction(0.8), .large])
                }
                
                // 정보란
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
                    
                    HStack{
                        Button {
                            
                        } label: {
                            Text("메세지 보내기")
                        }
                        .buttonStyle(WhiteButtonStyle(height: 40.0, font: .headline))
                        
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            Text("대여 신청")
                        }
                        .buttonStyle(AccentButtonStyle(height: 40.0, font: .headline))
                    }
                    
                    HStack {
                        Spacer()
                        Text("책 소유자 : ")
                        Text(user.nickName)
                        Image(user.image ?? "default")
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 30, height: 30)
                    }
                    
                    Divider()
                        .padding(.vertical, 10)
                    
                    Section{
                        Text("작품소개")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        Text(book.contents)
                            .font(.system(size: 13))
                    }
                    
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
                    
                    Divider()
                        .padding(.vertical)
                    
                    // 책 목록
                    Text("📖 읽고싶은 책인데 대여중이라면?")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.bottom, 5)
                    
                    VStack{
                        BookDetailUserListView(book: book, user: user)
                        BookDetailUserListView(book: book, user: user)
                        BookDetailUserListView(book: book, user: user)
                        BookDetailUserListView(book: book, user: user)
                    }
                }
                .padding(.horizontal)
                .navigationTitle(book.title)
            }
            SpaceBox()
        }
        .ignoresSafeArea()
        SpaceBox()
            .onAppear {
                Task {
                    user = await UserService.shared.loadUserByID(book.ownerID)
                    print("생성")
                }
            }
    }
}



//#Preview {
//    BookDetailView(book: Book(owenerID: "", title: "책이름", contents: "줄거리", authors: ["작가"], rentalState: RentalStateType(rawValue: "") ?? .rentalAvailable), user: User(id: "책유저", nickName: "닉네임", address: "주소"))
//}
