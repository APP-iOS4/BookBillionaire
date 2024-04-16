//
//  ProfileView.swift
//  BookBillionaireUser
//
//  Created by Woo Sung jong on 4/3/24.
//

import SwiftUI
//import FirebaseAuth
import BookBillionaireCore
import PhotosUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var isLoggedIn: Bool = false
    @State private var userEmail: String? // New state variable to hold user's email
    @State private var userUID: String? // New state variable to hold user's UID
    @State var user: User = User()
    let userService: UserService = UserService.shared
    @State var isShowingDialog: Bool = false
    @State private var isShowingPhotosPicker: Bool = false
    @State private var selectedImage: UIImage?
    @State private var selectedItem: PhotosPickerItem?
    
    var body: some View {
        VStack(alignment: .leading){
            Text("마이 프로필")
                .font(.title.bold())
            if authViewModel.state == .loggedOut {
                UnlogginedView()
            } else {
                Section {
                    HStack(spacing: 20) {
                        if let image = selectedImage {
                            Button {
                                isShowingDialog.toggle()
                            } label: {
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                                    .overlay(CameraOverlay(), alignment: .bottomTrailing)
                            }
                        } else {
                            Button {
                                isShowingDialog.toggle()
                            } label: {
                                Image("defaultUser1")
                                    .resizable()
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                                    .overlay(CameraOverlay(), alignment: .bottomTrailing)
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            Text(user.nickName)
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
                Section("환경설정") {
                    List{
                        Text("개인정보 처리방침")
                        Button("로그아웃") {
                            //                        logout()
                        }
                    }
                    .listStyle(.plain)
                }
            }
        }
        .navigationTitle("마이 프로필")
        .photosPicker(isPresented: $isShowingPhotosPicker, selection: $selectedItem)
        .confirmationDialog("프로필", isPresented: $isShowingDialog, actions: {
            Button{
                isShowingPhotosPicker.toggle()
            } label: {
                Text("앨범에서 사진 선택")
            }
            
            Button{
                selectedImage = nil
            } label: {
                Text("기본 이미지로 변경")
            }
        }, message: {
            Text("프로필 사진 설정")
        })
        .onChange(of: selectedItem) { _ in
            Task {
                if let selectedItem,
                   let data = try? await selectedItem.loadTransferable(type: Data.self) {
                    if let image = UIImage(data: data) {
                        selectedImage = image
                    }
                }
            }
        }
        .padding()
        .onAppear{
//            userUID = authViewModel.currentUser?.uid
            loadMyProfile()
        }
    }
    
    private func loadMyProfile() {
            Task {
                if let currentUser = AuthViewModel.shared.currentUser {
                    user = await userService.loadUserByID(currentUser.uid)
                }
            }
        }
    
//    func logout() {
//        do {
//            try Auth.auth().signOut()
//            authViewModel.state = .loggedOut // 로그아웃 상태로 변경
//            userEmail = nil // 이메일 초기화
//            userUID = nil // UID 초기화
//        } catch {
//            print("로그아웃 중 오류 발생:", error.localizedDescription)
//        }
//    }
}

#Preview {
    ProfileView(user: User())
        .environmentObject(AuthViewModel())
}
