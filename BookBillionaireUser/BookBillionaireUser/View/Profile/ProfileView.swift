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
    @EnvironmentObject var bookService: BookService
    @State var rentalService = RentalService()
    @State var user = User()
    @State private var isLoggedIn: Bool = false
    @State private var userEmail: String? // New state variable to hold user's email
    @State private var userUID: String? // New state variable to hold user's UID
    @State private var selectedImage: UIImage?
    private var PrivatePolicyUrl = Bundle.main.url(forResource: "PrivatePolicy", withExtension: "html")!
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading) {
                if authViewModel.state == .loggedOut {
                    UnlogginedView()
                        .padding()
                } else {
                    Section {
                        HStack(spacing: 20) {
                            ProfilePhoto(user: userService.currentUser, selectedImage: $selectedImage)
                            VStack(alignment: .leading) {
                                Text(userService.currentUser.nickName)
                                    .bold()
                                Text(userService.currentUser.address)
                            }
                        }
                        .padding()
                    }
                    
                    Section {
                        NavigationLink {
                            EditProfileView(user: $userService.currentUser, selectedImage: $selectedImage)
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 5.0)
                                    .foregroundStyle(.thinMaterial)
                                    .frame(height: 50)
                                    .padding()
                                Label("프로필 수정", systemImage: "pencil")
                            }
                        }
                    }
                    Divider()
                        .padding(.vertical)
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
                    .padding(.horizontal)
                    .padding(.top)
                    .navigationTitle("마이 프로필")
                }
            }
           
            //                    .onAppear{
            //                        // loadMyProfile()
            //                    }
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
}


#Preview {
    NavigationStack {
        ProfileView()
            .environmentObject(AuthViewModel())
            .environmentObject(UserService())
            .environmentObject(BookService())

    }
}
