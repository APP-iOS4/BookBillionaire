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

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var userService: UserService
    @EnvironmentObject var bookService: BookService
    @StateObject var profileViewModel = ProfileViewModel(userService: UserService(), bookService: BookService(), authViewModel: AuthViewModel())
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
    @State private var sholudLogout: Bool = false
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
                            SettingButton(sholudLogout: $sholudLogout, buttonType: settingButton)
                        }
                    }
                    .onChange(of: sholudLogout) { newValue in
                        if newValue {
                            profileViewModel.logout()
                        }
                    }
                }
                .padding()
                .navigationTitle("마이 프로필")
                .navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    if let currnetUser = AuthViewModel.shared.currentUser {
                        profileViewModel.loadFavoriteBooksCount(userID: currnetUser.uid)
                        profileViewModel.loadMyBooksCount(userID: currnetUser.uid)
                    }
                }
            }
        }
    }
}


#Preview {
    NavigationStack {
        ProfileView(profileViewModel: ProfileViewModel(userService: UserService(), bookService: BookService(), authViewModel: AuthViewModel()))
            .environmentObject(AuthViewModel())
            .environmentObject(UserService())
            .environmentObject(BookService())
    }
}

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
            HStack(spacing: 0) {
                Spacer()
                VStack {
                    Text("\(profileViewModel.myBooksCount)")
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
                    Text("\(profileViewModel.favoriteBooksCount)")
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
