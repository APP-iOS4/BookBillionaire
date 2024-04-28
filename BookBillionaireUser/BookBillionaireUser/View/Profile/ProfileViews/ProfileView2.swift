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
    case policy = "개인정보 처리방침"
    case logout = "로그아웃"
}

struct ProfileView2: View {
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
    let imageChache = ImageCache.shared
    @State private var favoriteBooksImages: [String: URL] = [:]
    @State private var loadedImages: [String: UIImage] = [:]
    // 스크롤 추적
    @State private var scrollViewOffset: CGFloat = 0
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
                    VStack(alignment: .leading, spacing: 0){
                        Text("책 돌려주는 날")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.bottom, 10)
                        Rectangle()
                            .frame(height: 200)
                    }
                    
                    Divider()
                        .padding(.vertical, 10)
                    LazyVStack(alignment: .leading) {
                        ForEach(SettingMenuType.allCases, id: \.self) { settingButton in
                            SettingButton(buttonType: settingButton)
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
        do {
            try Auth.auth().signOut()
            authViewModel.state = .loggedOut // 로그아웃 상태로 변경
            userEmail = nil // 이메일 초기화
            userUID = nil // UID 초기화
        } catch {
            print("로그아웃 중 오류 발생:", error.localizedDescription)
        }
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
        ProfileView2()
            .environmentObject(AuthViewModel())
            .environmentObject(UserService())
            .environmentObject(BookService())
    }
}

extension ProfileView2 {
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
            HStack(spacing: 0) {
                Spacer()
                VStack {
                    Text("\(myBooksCount)")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text("보유도서")
                        .font(.body)
                }
                Spacer()
                
                VStack {
                    Text("0")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text("빌린도서")
                        .font(.body)
                }
                Spacer()
                VStack {
                    Text("\(favoriteBooksCount)")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text("즐겨찾기")
                        .font(.body)
                }
            }
            .padding(.bottom, 50)
        }
    }
}
