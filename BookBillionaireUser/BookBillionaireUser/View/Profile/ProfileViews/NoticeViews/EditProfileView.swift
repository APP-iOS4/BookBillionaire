//
//  EditProfileView.swift
//  BookBillionaireUser
//
//  Created by Woo Sung jong on 4/16/24.
//

import SwiftUI
import PhotosUI
import BookBillionaireCore
import FirebaseFirestore
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
    
    @State private var nameText: String = ""
    @State private var emailText: String = ""
    @State private var passwordText: String = ""
    @State private var passwordConfirmText: String = ""
    @State private var nicknameValidated: Bool = false
    @State private var emailValidated: Bool = false
    @State private var disableControlls: Bool = false
    @State private var showDeleteConfirmation = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var deleteConfirmed: Bool = false
    @State private var alertTitle: String = ""
    
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
                
                Text("회원탈퇴")
                    .foregroundStyle(.primary)
                    .padding(.top, 30)
                HStack {
                    Text("탈퇴하려고? 후회할텐데..?")
                        .foregroundStyle(.primary)
                    Spacer()
                    Button(action: {
                        showDeleteConfirmation = true
                    }) {
                        Text("회원탈퇴")
                            .padding()
                            .background(Color.black.opacity(0.1))
                            .cornerRadius(10)
                    }
                    .padding()
                    .confirmationDialog("회원 탈퇴를 하시면 보유 도서 및 빌린 도서 현황을 보실 수 없으며, 재가입 시에도 복구되지 않습니다. 정말 탈퇴 하시겠습니까?", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
                        Button("예", role: .destructive) {
                            deleteUserAccount()
                            deleteConfirmed = true
                            dismiss()
                        }
                        Button("아니오", role: .cancel) {}
                    }
                    .alert("회원정보가 모두 삭제 되었으며, 회원 탈퇴 되었습니다.", isPresented: $deleteConfirmed) {
                        Button("OK", role: .cancel) {}
                    }
                }
                
            }
            .padding()
            .onAppear {
                nameText = user.nickName
                emailText = user.email
                tempAddress = user.address
            }
            .toolbar {
                 ToolbarItem(placement: .navigationBarTrailing) {
                     Button {
                         Task {
                             await updateProfile()
                         }
                     } label: {
                         Text("저장")
                     }
                 }
             }
            .alert(alertTitle, isPresented: $showAlert) {
                Button("OK", role: .cancel) {
                    if alertTitle == "마이 프로필이 수정 되었습니다." {
                        dismiss()
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
    
    func updateProfile() async {
        disableControlls = true
        let updateResult = await performUpdateSignUp()
        disableControlls = false
        if updateResult {
            alertTitle = "마이 프로필이 수정 되었습니다."
            user.nickName = nameText
            user.email = emailText
            user.address = tempAddress
        } else {
            alertTitle = "마이 프로필 수정이 실패 하였습니다. \n닉네임과 이메일 중복체크를 해주세요.\n모든 필드를 올바르게 입력 해주세요."
        }
        showAlert = true
    }
    
    private func performUpdateSignUp() async -> Bool {
        guard !nameText.isEmpty, !emailText.isEmpty, passwordText.count >= 6, passwordText == passwordConfirmText, nicknameValidated, emailValidated else {
            alertMessage = "모든 필드를 올바르게 입력 해주세요."
            showAlert = true
            return false
        }

        // 닉네임과 이메일의 중복 검사 로직 (AuthViewModel 사용)
        AuthViewModel.shared.checkNicknameDuplication(nameText) { isUniqueNickname in
            if !isUniqueNickname {
                print("닉네임이 중복됩니다. 다른 닉네임을 사용해주세요.")
            } else {
                AuthViewModel.shared.checkEmailDuplication(emailText) { isUniqueEmail in
                    if !isUniqueEmail {
                        print("이메일이 중복됩니다. 다른 이메일을 사용해주세요.")
                    } else {
                        // 모든 조건이 충족되면 실제 회원 가입 진행
                        disableControlls = true
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
            }
        }
        return true
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
    
    private func deleteUserAccount() {
        guard let user = AuthViewModel.shared.currentUser else { return }
        
        // Delete the user's account
        user.delete { error in
            if let error = error {
                // Handle any errors (e.g., user needs to re-authenticate)
                print("Error deleting user: \(error.localizedDescription)")
            } else {
                deleteUserDataFromFirestore(userID: user.uid)
                AuthViewModel.shared.signOut()

                // Handle post-deletion logic, such as navigating to the login screen
                // Assuming there is a method to call when deletion is successful:
                handleUserDidDeleteAccount()
            }
        }
    }
    
    private func deleteUserDataFromFirestore(userID: String) {
        let db = Firestore.firestore()
        db.collection("User").document(userID).delete { error in
            if let error = error {
                print("Error deleting user data from Firestore: \(error.localizedDescription)")
            } else {
                print("User data successfully deleted from Firestore")
                // Handle post-deletion logic, such as navigating to the login screen
                handleUserDidDeleteAccount()
            }
        }
    }

    private func handleUserDidDeleteAccount() {
        // Logic after user account is deleted, e.g., navigate to the login or welcome screen
    }
}

#Preview {
    NavigationStack {
        EditProfileView(user: .constant(User()), selectedImage: .constant(UIImage()))
            .environmentObject(UserService())
    }
}
