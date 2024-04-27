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
    
    var body: some View {
        VStack(alignment: .leading) {
            if authViewModel.state == .loggedIn {
                UnlogginedView()
                    .padding()
            } else {
                ScrollView(showsIndicators: false) {
                    userProfileView
                    Divider()
                        .padding(.vertical, 10)
                    VStack(alignment: .leading, spacing: 0){
                        Text("내가 관심있는 책")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.bottom, 10)
                        wishListScrollView
                            .frame(height: 250)
                            
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
                        fetchFavoriteBooksImages(userID: currnetUser.uid)
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
    
    // 즐겨찾기
    func loadFavoriteBooksCount(userID: String) {
        Task {
            favoriteBooksCount = await userService.getFavoriteBooksCount(userID: userID)
        }
    }
    
    // 이미지의 위치에 따라 스케일 팩터를 계산하는 함수
    private func scaleFactor(geometry: GeometryProxy, itemGeometry: GeometryProxy) -> CGFloat {
        let itemFrame = itemGeometry.frame(in: .global) // 이미지 위치 크기정보 (전역 좌표)
        let itemViewCenter = itemFrame.minX + itemFrame.width / 2 // 이미지 중심 x좌표 계산
        let viewCenter = geometry.size.width / 2 // 뷰 중심 x 좌표 계산
        let distanceFromCenter = abs(itemViewCenter - viewCenter) // 이미지 중심과 뷰 중심 사이 거리 계산
        // 이미지의 스케일 팩터 계산
        let scaleFactor = 1 - (distanceFromCenter / geometry.size.width)
        // 스케일은 최소 0.9, 최대 1입니다.
        return max(0.8, min(scaleFactor, 1))
    }


    
    // 이미지 불러오기
    func fetchFavoriteBooksImages(userID: String) {
        Task {
            favoriteBooksImages = await userService.getFavoriteBooksImages(userID: userID)
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
                    Text("5")
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


extension ProfileView2 {
    var wishListScrollView: some View {
        VStack(spacing: 0) {
            GeometryReader { geometry in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(alignment: .center, spacing: 0) {
                        ForEach(favoriteBooksImages.keys.sorted(), id: \.self) { bookID in
                            GeometryReader { imageGeometry in
                                if let url = favoriteBooksImages[bookID],
                                   let loadedImage = loadedImages[bookID] {
                                    Image(uiImage: loadedImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: geometry.size.width / 3, height: 220)
                                        .background(
                                            Image(uiImage: loadedImage)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .blur(radius: 5)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                                .overlay(
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .stroke(Color.white, lineWidth: 3)
                                                    )
                                                .frame(width: 150)
                                        )
                                        .scaleEffect(scaleFactor(geometry: geometry, itemGeometry: imageGeometry))
                                     
                                } else {
                                    Image("default")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: geometry.size.width / 3, height: 220)
                                        .background(
                                            Image("default")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .blur(radius: 5)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                                .overlay(
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .stroke(Color.white, lineWidth: 3)
                                                    )
                                                .frame(width: 150)
                                        )
                                        .scaleEffect(scaleFactor(geometry: geometry, itemGeometry: imageGeometry))
                                }
                            }
                            .frame(width: geometry.size.width / 3)
                            .onAppear {
                                if let url = favoriteBooksImages[bookID] {
                                    ImageCache.shared.getImage(for: url) { image in
                                        loadedImages[bookID] = image
                                    }
                                }
                            }
                        }
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
            Spacer()
        }
    }
}
