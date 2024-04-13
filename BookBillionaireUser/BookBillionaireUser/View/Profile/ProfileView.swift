//
//  ProfileView.swift
//  BookBillionaireUser
//
//  Created by Woo Sung jong on 4/3/24.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var isLoggedIn: Bool = false
    @State private var userEmail: String? // New state variable to hold user's email
    @State private var userUID: String? // New state variable to hold user's UID
    @State private var user: User?
    
    var body: some View {
        VStack(alignment: .leading){
            Text("마이 프로필")
                .font(.title.bold())
            if authViewModel.state == .loggedOut {
                UnlogginedView()
            } else {}
            Section{
                HStack(spacing: 20) {
                    Image("defaultUser1")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                    VStack(alignment: .leading) {
                        Text("닉네임")
                            .bold()
                        Text("")
                    }
                }
                .padding()
            }
            Text("최근 살펴본 책 내역")
            HStack {
                Rectangle()
                Rectangle()
                Rectangle()
            }
            .frame(height: 100)
            .padding(.vertical)
            Section("환경설정"){
                List{
                    Text("개인정보 처리방침")
                    Button("로그아웃") {
                        logout()
                    }
                }.listStyle(.plain)
            }                    .navigationTitle("마이 프로필")
            
        }
        
        .padding()
        .onAppear{
            userUID = authViewModel.currentUser?.uid
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
    ProfileView()
        .environmentObject(AuthViewModel())
}
