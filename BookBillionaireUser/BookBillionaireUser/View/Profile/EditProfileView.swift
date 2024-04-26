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
    @EnvironmentObject var userService: UserService
    @State var isShowingDialog: Bool = false
    @State private var isShowingPhotosPicker: Bool = false
    @Binding var selectedImage: UIImage?
    @State private var selectedItem: PhotosPickerItem?
    @Environment(\.dismiss) private var dismiss
    @State var tempNickname: String = ""
    @State var tempAddress: String = ""
    //    @State var imageUrl: URL?
    
    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            Button {
                isShowingDialog.toggle()
            } label: {
                ProfilePhoto(user: user, selectedImage: $selectedImage)
                    .overlay(CameraOverlay(), alignment: .bottomTrailing)
            }
            
            VStack {
                HStack {
                    Text("닉네임")
                        .font(.caption)
                        .foregroundStyle(Color.gray)
                    Spacer()
                }
                TextField("닉네임을 입력해주세요.", text: $tempNickname)
                    .textFieldStyle(.roundedBorder)
            }
            
            VStack {
                HStack {
                    Text("주소")
                        .font(.caption)
                        .foregroundStyle(Color.gray)
                    Spacer()
                }
                TextField("주소를 입력해주세요.", text: $tempAddress)
                    .textFieldStyle(.roundedBorder)
            }
            
            Spacer()
        }
        .padding()
        .onAppear {
            tempNickname = user.nickName
            tempAddress = user.address
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    user.nickName = tempNickname
                    user.address = tempAddress
                    uploadPhoto()
                    updateMyProfile()
                    dismiss()
                } label: {
                    Text("저장")
                }
            }
        }
        .photosPicker(isPresented: $isShowingPhotosPicker, selection: $selectedItem, matching: .images)
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
                await userService.updateUserByID(currentUser.uid, nickname: tempNickname, imageUrl: user.image ?? "defaultUser", address: user.address)
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
