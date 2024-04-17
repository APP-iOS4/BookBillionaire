//
//  ProfileView.swift
//  BookBillionaireUser
//
//  Created by Woo Sung jong on 4/3/24.
//

import SwiftUI
//import FirebaseAuth
import BookBillionaireCore
import FirebaseAuth

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var userService: UserService
    @State private var isLoggedIn: Bool = false
    @State private var userEmail: String? // New state variable to hold user's email
    @State private var userUID: String? // New state variable to hold user's UID
    @State private var selectedImage: UIImage?
    @State private var user = User()
    private var PrivatePolicyUrl = Bundle.main.url(forResource: "PrivatePolicy", withExtension: "html")!
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading) {
                if authViewModel.state == .loggedOut {
                    UnlogginedView()
                } else {
                    Section {
                        HStack(spacing: 20) {
                            ProfilePhoto(user: user, selectedImage: $selectedImage)
                            VStack(alignment: .leading) {
                                Text(user.nickName)
                                    .bold()
                                Text(user.address)
                            }
                        }
                        .padding()
                    }
                    
                    Section {
                        NavigationLink {
                            EditProfileView(user: $user, selectedImage: $selectedImage)
                        } label: {
                            ZStack {
                                Rectangle()
                                    .foregroundStyle(Color.clear)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                Label("프로필 수정", systemImage: "pencil")
                            }
                        }
                    }
                    
                    Section("최근 살펴본 책 내역") {
                        HStack {
                            Rectangle()
                            Rectangle()
                            Rectangle()
                        }
                        .frame(height: 100)
                        .padding(.vertical)
                    }
                    
                    Section("환경설정") {
                        List{
                            NavigationLink {
                                WebView(url: PrivatePolicyUrl)
                            } label: {
                                Text("개인정보처리방침")
                            }

                            Button("로그아웃") {
                                logout()
                            }
                        }
                        .listStyle(.plain)
                    }
                    .navigationTitle("마이 프로필")
                }
            }
            .padding()
            .onAppear{
                loadMyProfile()
            }
        }
    }
    private func loadMyProfile() {
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
        
}

//#Preview {
//    NavigationStack {
//        ProfileView(user: User())
//            .environmentObject(AuthViewModel())
//    }
//}
