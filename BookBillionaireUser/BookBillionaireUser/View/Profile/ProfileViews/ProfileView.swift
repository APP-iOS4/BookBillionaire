//
//  ProfileView2.swift
//  BookBillionaireUser
//
//  Created by 홍승표 on 4/26/24.
//

import SwiftUI
import BookBillionaireCore
import FirebaseAuth
import FirebaseStorage

enum SettingMenuType: String, CaseIterable {
    case notice = "공지사항"
    case qanda = "Q&A"
    case policy = "개인정보처리방침"
    case termsOfouse = "위치기반서비스 이용약관"
    case logOut = "로그아웃"
}

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var userService: UserService
    @EnvironmentObject var bookService: BookService
    @State private var selectedImage: UIImage?
    @State private var favoriteBooksCount: Int = 0
    @State private var myBooksCount: Int = 0
    @State var user = User()
    // 파베어스
    @State private var isLoggedIn: Bool = false
    @State private var userEmail: String? // New state variable to hold user's email
    @State private var userUID: String? // New state variable to hold user's UID
    // 네비
    @State private var isGoToProfilePhoto: Bool = false
    @State private var shouldLogout: Bool = false
    @State private var isGoToMyBooks = false
    @State private var isGoToBorrowedBooks = false
    @State private var isGoToFavorites = false
    @State private var MyBookDetailInfoSelectedTab = 0
    // 이미지
    let imageChache = ImageCache.shared
    
    var body: some View {
        VStack(alignment: .leading) {
            if authViewModel.state == .loggedOut {
                UnlogginedView()
                    .padding()
            } else {
                ScrollView(showsIndicators: false) {
                    userProfileView
                    Divider()
                        .padding(.vertical, 10)
                    // 반납일자 캘린더
                    userCalenderView
                    Divider()
                        .padding(.vertical, 10)
                    // 공지사항 & 약관으로 이동
                    LazyVStack(alignment: .leading) {
                        ForEach(SettingMenuType.allCases, id: \.self) { settingButton in
                            SettingButton(shouldLogout: $shouldLogout, buttonType: settingButton)
                        }
                    }
                    .onChange(of: shouldLogout) { newValue in
                        if newValue {
                            logout()
                        }
                    }
                }
                .padding()
                .navigationTitle("마이 프로필")
                .navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    if let currnetUser = AuthViewModel.shared.currentUser {
                        loadFavoriteBooksCount(userID: currnetUser.uid)
                        loadMyBooksCount(userID: currnetUser.uid)
                    }
                }
            }
        }
    }
    
    func loadMyProfile() {
        Task {
            if let currentUser = AuthViewModel.shared.currentUser {
                user = userService.loadUserByID(currentUser.uid)
            }
        }
    }
    func logout() {
            AuthViewModel.shared.signOut()
            authViewModel.state = .loggedOut // 로그아웃 상태로 변경
            userEmail = nil // 이메일 초기화
            userUID = nil // UID 초기화
    }
    
    func loadFavoriteBooksCount(userID: String) {
        Task {
            favoriteBooksCount = await userService.getFavoriteBooksCount(userID: userID)
        }
    }
    
    func loadMyBooksCount(userID: String) {
        Task {
            myBooksCount = await userService.getMyBookCount(userID: userID)
        }
    }
    
}


#Preview {
    NavigationStack {
        ProfileView()
            .environmentObject(AuthViewModel())
            .environmentObject(UserService())
            .environmentObject(BookService())
            .environmentObject(HtmlLoadService())
    }
}

//MARK: - 유저 사진 & 정보
extension ProfileView {
    var userProfileView: some View {
        HStack(alignment: .center, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                ProfilePhoto(user: userService.currentUser, selectedImage: $selectedImage)
                    .overlay(OverlayImage(imageName: "pencil.circle.fill"), alignment: .bottomTrailing)
                    .padding(.bottom, 10)
                VStack(alignment: .leading, spacing: 5) {
                    Text(userService.currentUser.nickName)
                        .font(.title3)
                        .fontWeight(.bold)
                    Text(userService.currentUser.address)
                        .foregroundStyle(.gray)
                }
            }
            .onTapGesture {
                isGoToProfilePhoto = true
            }
            .navigationDestination(isPresented: $isGoToProfilePhoto) {
                EditProfileView(user: $userService.currentUser, selectedImage: $selectedImage)
            }
            // 각각의 상세 리스트 나오는 뷰로 이동
            HStack(spacing: 0) {
                Spacer()
                VStack {
                    Text("\(myBooksCount)")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text("보유도서")
                        .font(.body)
                }
                .onTapGesture {
                    MyBookDetailInfoSelectedTab = 0
                    isGoToMyBooks = true
                }
                .navigationDestination(isPresented: $isGoToMyBooks) {
                    MyBookDetailInfoView(selectedTab: $MyBookDetailInfoSelectedTab)
                }
                Spacer()
                VStack {
                    Text("0")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text("빌린도서")
                        .font(.body)
                }
                .onTapGesture {
                    MyBookDetailInfoSelectedTab = 1
                    isGoToBorrowedBooks = true
                }
                .navigationDestination(isPresented: $isGoToBorrowedBooks) {
                    MyBookDetailInfoView(selectedTab: $MyBookDetailInfoSelectedTab)
                }
                Spacer()
                VStack {
                    Text("\(favoriteBooksCount)")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text("즐겨찾기")
                        .font(.body)
                }
                .onTapGesture {
                    MyBookDetailInfoSelectedTab = 2
                    isGoToFavorites = true
                }
                .navigationDestination(isPresented: $isGoToFavorites) {
                    MyBookDetailInfoView(selectedTab: $MyBookDetailInfoSelectedTab)
                }
            }
            .padding(.bottom, 50)
        }
    }
}


//MARK: - 반납일자 캘린더
extension ProfileView {
    var userCalenderView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("책 돌려줄 날")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.bottom, 12)
            CalenderView()
                .padding(2)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.accentColor)
                )
        }
    }
}

