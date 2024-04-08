//
//  ProfileView.swift
//  BookBillionaireUser
//
//  Created by Woo Sung jong on 4/3/24.
//

import SwiftUI
import TipKit
import FirebaseAuth

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var isLoggedIn: Bool = false
    @State private var userEmail: String? // New state variable to hold user's email
    @State private var userUID: String? // New state variable to hold user's UID
    
    
    var body: some View {
        VStack {
            NavigationStack {
                VStack {
                    VStack {
                        
                        Text("기본정보")
                        if let email = userEmail {
                            Text(email)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        if let UID = userUID {
                            Text(UID)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding(.bottom, 10)
                        }
                        
                        
                    }
                    if authViewModel.state == .logIn {
                        Button(action: {
                            logout()
                        }, label: {
                            Text("로그아웃")
                                .foregroundColor(.red)
                                .padding()
                        })
                    } else {
                        Button(action: {
                            isLoggedIn = true
                        }, label: {
                            Text("로그인")
                                .foregroundColor(.blue)
                                .padding()
                        })
                    }
                }
            }
            .onAppear {
                // Check if the user is logged in
                authViewModel.state = Auth.auth().currentUser != nil ? .logIn : .logOut
                isLoggedIn = authViewModel.state == .logOut ? true : false
                
                // If user is logged in, fetch and store user's email
                if authViewModel.state == .logIn {
                    if let user = Auth.auth().currentUser {
                        userEmail = user.email
                        userUID = user.uid
                    }
                }
            }
            .onReceive(authViewModel.$state) { newState in
                isLoggedIn = newState == .logOut ? true : false
                
                // If user is logged in, fetch and store user's email
                if newState == .logIn {
                    if let user = Auth.auth().currentUser {
                        userEmail = user.email
                        userUID = user.uid
                        
                    }
                } else {
                    userEmail = nil // Clear email if user logs out
                }
            }
            .fullScreenCover(isPresented: $isLoggedIn, content: {
                NavigationView { // NavigationView 추가
                    if authViewModel.state == .logOut { // Check if the user is logged in
                        LoginView()
                            .navigationBarItems(trailing: Button(action: {
                                isLoggedIn = false // 닫기 버튼을 누르면 fullScreenCover를 닫음
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.white)
                                    .imageScale(.large)
                            })
                    }
                }
            })
        }
        

    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            authViewModel.state = .logOut // 로그아웃 상태로 변경
            userEmail = nil // 이메일 초기화
            userUID = nil // UID 초기화
        } catch {
            print("로그아웃 중 오류 발생:", error.localizedDescription)
        }
    }
}


#Preview {
    ProfileView()
}
