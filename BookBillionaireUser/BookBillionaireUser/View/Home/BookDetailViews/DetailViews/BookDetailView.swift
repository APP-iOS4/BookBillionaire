//
//  BookDetailView.swift
//  BookBillionaireUser
//
//  Created by 홍승표 on 4/3/24.
//


import SwiftUI
import BookBillionaireCore
import FirebaseStorage

struct BookDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    let book: Book
    @State var user: User = User()
    @EnvironmentObject var userService: UserService
    @StateObject var commentViewModel = ReviewViewModel()
    
    let imageChache = ImageCache.shared
    @State private var imageUrl: URL?
    @State private var loadedImage: UIImage?
    //채팅
    @EnvironmentObject var authViewModel: AuthViewModel
    @State var roomListVM: ChatListViewModel = ChatListViewModel()
    @State var roomModel: ChatRoom = ChatRoom(id: "", receiverName: "", lastTimeStamp: Date(), lastMessage: "", users: [])
    @State private var isShowingSheet: Bool = false
    @State private var isFavorite: Bool = false
    @State private var showLoginAlert = false
    @State private var isChatViewPresented = false
    @Binding var selectedTab: ContentView.Tab
    @State private var roomId: String? // 생성한 방의 id를 담는 변수
    
    // 렌탈
    let rentalService = RentalService()
    @State var rentalTime: (Date, Date) = (Date(), Date())
    @State var rental: Rental = Rental()
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd"
        return formatter
    }
    
    var body: some View {
        ScrollView {
            bookDetailImage
                .frame(height: 333)
                .padding(.top, 30)
            
            VStack(alignment: .leading) {
                bookTitleView
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
                                        selectedTab = .chat
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
                        //                        .background(
                        //                            NavigationLink(destination: ChatListView(), isActive: $isChatViewPresented) {
                        //                                EmptyView()
                        //                            }
                        //                                .hidden()
                        //                        )
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
                    
                    Divider()
                        .padding(.vertical, 10)
                    bookDetailInfo
                        .onAppear {
                            Task {
                                rentalTime = await rentalService.getRentalDay(rental.id)
                            }
                        }
                }
                
                Divider()
                    .padding(.vertical, 10)
                BookAnotherOwnerView(book: book, user: user)
                
                Divider()
                    .padding(.vertical, 10)
                BookDetailReviewView(comments: commentViewModel.comments, user: user)
            }
            .padding(.horizontal)
            .navigationTitle(book.title)
            .toolbarBackground(.visible, for: .navigationBar)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack {
                            Menu {
                                if let url = URL(string: "https://github.com/tv1039") {
                                    ShareLink(item: url) {
                                        Label("게시물 공유하기", systemImage: "square.and.arrow.up")
                                    }
                                }
                                
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
                        }
                        .sheet(isPresented: $isShowingSheet) {
                            BottomSheet(isShowingSheet: $isShowingSheet)
                                .presentationDetents([.fraction(0.8), .large])
                        }
                        
                    }
                }
        }
    }
    
    func calculateTotalDays() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: rentalTime.0, to: rentalTime.1)
        return components.day ?? 0
    }
}

#Preview {
    BookDetailView(book: Book(ownerID: "", ownerNickname: "책 소유자", title: "책 제목", contents: "줄거리", authors: ["작가"], rentalState: RentalStateType(rawValue: "") ?? .rentalAvailable), user: User(nickName: "닉네임", address: "주소", email: "aaa@gamil.com"), selectedTab: .constant(.home))
        .environmentObject(AuthViewModel())
        .environmentObject(UserService())
}


extension BookDetailView {
    var bookDetailImage: some View {
        ZStack{
            if let url = imageUrl, !url.absoluteString.isEmpty {
                if let loadedImage = loadedImage {
                    Image(uiImage: loadedImage)
                        .resizable(resizingMode: .stretch)
                        .ignoresSafeArea()
                        .blur(radius: 8.0, opaque: true)
                        .background(Color.gray)
                } else {
                    Image("default")
                        .resizable(resizingMode: .stretch)
                        .ignoresSafeArea()
                        .blur(radius: 8.0, opaque: true)
                        .background(Color.gray)
                        .onAppear {
                            ImageCache.shared.getImage(for: url) { image in
                                loadedImage = image
                            }
                        }
                }
            } else {
                Image("default")
                    .resizable(resizingMode: .stretch)
                    .ignoresSafeArea()
                    .blur(radius: 8.0, opaque: true)
                    .background(Color.gray)
            }
            
            VStack(alignment: .center){
                UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 25.0, topTrailing: 25.0))
                    .frame(height: 300)
                    .foregroundStyle(colorScheme == .dark ? .black : .white)
                    .padding(.top, 300)
            }
            
            GeometryReader { geometry in
                if let image = loadedImage {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 200, height: 300)
                        .background(Color.gray)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                } else {
                    Image(uiImage: UIImage(named: "default") ?? UIImage())
                        .resizable()
                        .frame(width: 200, height: 300)
                        .background(Color.gray)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }
            }
            
        }
        .onAppear {
            // 앞글자에 따라 imageURL에 할당하는 조건
            if book.thumbnail.hasPrefix("http://") || book.thumbnail.hasPrefix("https://") {
                imageUrl = URL(string: book.thumbnail)
            } else {
                // Firebase Storage 경로 URL 다운로드
                let storageRef = Storage.storage().reference(withPath: book.thumbnail)
                storageRef.downloadURL { (url, error) in
                    if let error = error {
                        print("Error getting download URL: \(error)")
                    } else if let url = url {
                        imageUrl = url
                    }
                }
            }
        }
    }
}

extension BookDetailView {
    var bookTitleView: some View {
        HStack(alignment: .center){
            Text(book.title)
                .font(.title2)
                .fontWeight(.bold)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
            
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
            StatusButton(status: book.rentalState)
        }
    }
}
extension BookDetailView {
    var bookDetailInfo: some View {
        VStack(alignment: .leading) {
            HStack {
                if let url = URL(string: user.image ?? "") {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 30, height: 30)
                    } placeholder: {
                        Image("default")
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 30, height: 30)
                    }
                } else {
                    Image("default")
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 30, height: 30)
                }
                VStack(alignment: .leading) {
                    Text("\(user.nickName)")
                        .font(.body)
                    Text("강서구")
                        .font(.caption)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("\(dateFormatter.string(from: rentalTime.0)) - \(dateFormatter.string(from: rentalTime.1)) (\(calculateTotalDays())일)")
                        .font(.subheadline)
                    Text("대여 가능 기간")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                
            }
            
            Divider()
                .padding(.vertical, 10)
            
           Text("기본 정보")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.bottom, 5)
            
            Text("책 소개")
                .font(.body)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
                .padding(.bottom, 3)
            Text(book.contents)
                .lineSpacing(5)
                .font(.subheadline)
            Divider()
                .padding(.vertical, 10)
            
            VStack(alignment: .leading) {
                Text("저자 및 역자")
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                    .padding(.bottom, 5)
                
                VStack(alignment: .leading) {
                    if book.authors.isEmpty {
                        if let translators = book.translators,
                            !translators.isEmpty{
                            ForEach(translators, id: \.self) { translator in
                                Text("옮긴이: \(translator)")
                                    .font(.subheadline)
                            }
                        }
                    }
                    else {
                        ForEach(book.authors, id: \.self) { author in
                            Text("\(author)")
                                .font(.subheadline)
                        }
                    }
                }
            }
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .font(.subheadline)
            .foregroundStyle(.primary)
            .padding(.bottom, 10)
            
            Text("카테고리")
                .font(.body)
                .fontWeight(.bold)
                .padding(.bottom, 5)
            Text(book.bookCategory?.rawValue ?? "카테고리")
                .font(.subheadline)
            
        }
    }
}