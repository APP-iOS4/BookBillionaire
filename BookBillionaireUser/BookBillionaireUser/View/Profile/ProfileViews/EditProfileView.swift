//
//  EditProfileView.swift
//  BookBillionaireUser
//
//  Created by Woo Sung jong on 4/16/24.
//

import SwiftUI
import PhotosUI
import BookBillionaireCore
import FirebaseStorage

struct EditProfileView: View {
    @Binding var user: User
    @Binding var selectedImage: UIImage?
    
    @EnvironmentObject var userService: UserService
    @Environment(\.dismiss) private var dismiss
    
    @State var isShowingDialog: Bool = false
    @State private var isShowingPhotosPicker: Bool = false
    @State private var selectedItem: PhotosPickerItem?
    @State var tempAddress: String = ""
    
    @State private var nameText = ""
    @State private var emailText = ""
    @State private var passwordText = ""
    @State private var passwordConfirmText = ""
    @State private var nicknameValidated = false
    @State private var emailValidated = false
    @State private var disableControlls: Bool = false
    
    @StateObject private var locationManager = LocationManager()
    
    
    //    @State var imageUrl: URL?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Button {
                    isShowingDialog.toggle()
                } label: {
                    ProfilePhoto(user: user, selectedImage: $selectedImage)
                        .overlay(OverlayImage(imageName: "camera.circle.fill"), alignment: .bottomTrailing)
                }
                
                SignUpDetailView(nameText: $nameText, emailText: $emailText, passwordText: $passwordText, passwordConfirmText: $passwordConfirmText, nicknameValidated: $nicknameValidated, emailValidated: $emailValidated, disableControlls: $disableControlls)
                HStack {
                    Text("주소")
                        .foregroundStyle(.primary)
                    Spacer()
                    Button(action: {
                        locationManager.requestLocation()
                        tempAddress = removeDuplicateWords(from: locationManager.currentAddress)
                    }, label: {
                        Text("주소인증")
                            .foregroundColor(.primary)
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(.primary)
                    })
                    .padding(.trailing, 15)
                }
                TextField("주소를 입력해주세요.", text: $tempAddress)
                    .padding()
                    .background(.thinMaterial)
                    .cornerRadius(10)
                    .textInputAutocapitalization(.none)
                    .autocapitalization(.none)
                    .disabled(true)
            }
            .padding()
            .onAppear {
                nameText = user.nickName
                emailText = user.email
                tempAddress = user.address
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        user.nickName = nameText
                        user.address = tempAddress
                        uploadPhoto()
                        updateMyProfile()
                        dismiss()
                    } label: {
                        Text("저장")
                    }
                }
            }
            .photosPicker(isPresented: $isShowingPhotosPicker, selection: $selectedItem)
            .confirmationDialog("프로필", isPresented: $isShowingDialog, actions: {
                Button{
                    isShowingPhotosPicker.toggle()
                } label: {
                    Text("앨범에서 사진 선택")
                }
                
                Button{
                    selectedItem = nil
                    selectedImage = UIImage(named: "defaultUser1")
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
        }
    }
    
    func removeDuplicateWords(from text: String) -> String {
        let words = text.components(separatedBy: " ")
        var seenWords = Set<String>()
        let filteredWords = words.filter { seenWords.insert($0).inserted }
        return filteredWords.joined(separator: " ")
    }
    
    private func uploadPhoto() {
        guard let selectedItem = selectedItem else {
            return
        }
        Task {
            if let data = try? await selectedItem.loadTransferable(type: Data.self) {
                let storageRef = Storage.storage().reference()
                let path = "profile/\(user.id).jpg"
                user.image = path
                let fileRef = storageRef.child(path)
                let _ = fileRef.putData(data, metadata: nil) { metadata, error in
                    if error == nil && metadata != nil {
                        // Handle successful upload
                    } else if let error = error {
                        // Handle unsuccessful upload
                        print("Error uploading image: \(error)")
                    }
                }
            }
        }
    }
    
//    private func uploadPhoto() {
//        guard selectedImage != nil else {
//            return
//        }
//        let storageRef = Storage.storage().reference()
//        let imageData = selectedImage!.jpegData(compressionQuality: 0.8)
//        guard imageData != nil else {
//            return
//        }
//        let path = "profile/\(user.id).jpg"
//        user.image = path
//        let fileRef = storageRef.child(path)
//        let uploadTask = fileRef.putData(imageData!, metadata: nil) { metadata, error in
//            if error == nil && metadata != nil {
//            } else if let error = error {
//                // Handle unsuccessful upload
//                print("Error uploading image: \(error)")
//            }
//        }
//    }
    
    private func updateMyProfile() {
        Task {
            if let currentUser = AuthViewModel.shared.currentUser {
                // 아이디/패스워드 변경 로직
                AuthViewModel.shared.sendEmailVerification(newEmail: emailText) { success in
                    if success {
                        print("Please check your email to verify the new address.")
                    }
                }
                AuthViewModel.shared.updateUserPassword(newPassword: passwordText) { success in
                    if success {
                        print("Password updated.")
                    }
                }
                
                // 파이어베이스 다큐먼트 변경 로직
                await userService.updateUserByID(currentUser.uid, nickname: nameText, imageUrl: user.image ?? "defaultUser", address: user.address, emailEqualtoAuth: emailText)
            }
        }
    }
}

#Preview {
    NavigationStack {
        EditProfileView(user: .constant(User()), selectedImage: .constant(UIImage()))
            .environmentObject(UserService())
    }
}
