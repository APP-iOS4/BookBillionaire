//
//  AuthViewModel.swift
//  BookBillionaireUser
//
//  Created by Seungjae Yu on 3/25/24.
//  참조: https://elisha0103.tistory.com/10

import Firebase
import GoogleSignIn
import FirebaseAuth

class AuthViewModel: ObservableObject, AuthViewModelProtocol {
    
    static let shared = AuthViewModel()
    
    @Published public var state: AuthState = .loggedOut
    @Published var errorMessage: String?  // Add this to handle error messages
    let signInMethod: SignInMethod = .email
    var currentUser: User? {
            if let user = Auth.auth().currentUser {
                return user
            }
            return nil
        }

    func signUp(email: String, userName: String, password: String, completion: @escaping (Bool) -> Void) {
        // 중복 체크
        checkEmailDuplication(email) { [weak self] isEmailUnique in
            guard let self = self else {
                completion(false)
                return
            }
            
            if !isEmailUnique {
                print("이미 등록된 이메일입니다.")
                completion(false)
                return
            }
            
            self.checkNicknameDuplication(userName) { isNicknameUnique in
                if !isNicknameUnique {
                    print("이미 사용 중인 닉네임입니다.")
                    completion(false)
                    return
                }
                
                // 이메일, 닉네임 중복이 없으면 회원가입 진행
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    if let error = error {
                        print("error: \(error.localizedDescription)")
                        completion(false)
                        return
                    }
                    
                    guard let result = result else {
                        completion(false)
                        return
                    }
                    
                    let changeRequest = result.user.createProfileChangeRequest()
                    changeRequest.displayName = userName
                    changeRequest.commitChanges { error in
                        if let error = error {
                            print("Error updating profile: \(error.localizedDescription)")
                            completion(false)
                            return
                        }
                        
                        // Firestore에 사용자 정보 및 생성일자 저장
                        let db = Firestore.firestore()
                        let userData: [String: Any] = [
                            "emailEqualtoAuth": email,
                            "nickname": userName,
                            "createdAt": Timestamp(date: Date()),
                            "id": result.user.uid,
                            "introduction": "",
                            "profileImage": "profile/defaultUser.jpeg"
                        ]
                        db.collection("User").document(result.user.uid).setData(userData) { error in
                            if let error = error {
                                print("Error saving user data: \(error.localizedDescription)")
                                completion(false)
                                return
                            }
                            print("사용자 데이터가 성공적으로 저장되었습니다.")
                            
                            // 사용자 데이터를 다시 읽어와서 출력
                            self.readUserData(uid: result.user.uid)
                            completion(true)
                        }
                    }
                }
            }
        }
    }

    
    func signIn(email: String?, password: String?) {
        if let email = email, let password = password {
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if let error = error {
                    // Update to handle the error by setting the errorMessage
                    DispatchQueue.main.async {
                        self.errorMessage = "아이디/패스워드가 일치 하지 않습니다."
                    }
                    print("error: \(error.localizedDescription)")
                    return
                }

                if result != nil {
                    self.state = .loggedIn
                    // Clear the error message upon successful login
                    DispatchQueue.main.async {
                        self.errorMessage = nil
                    }
                    print("사용자 이메일: \(String(describing: result?.user.email))")
                    print("사용자 이름: \(String(describing: result?.user.displayName))")
                }
            }
        }
    }
    
    func readUserData(uid: String) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(uid)
        userRef.getDocument { document, error in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                return
            }
            
            guard let document = document, document.exists else {
                print("사용자 데이터를 찾을 수 없습니다.")
                return
            }
            
            if let userData = document.data(), let nickname = userData["nickname"] as? String {
                print("사용자 닉네임: \(nickname)")
                if let createdAtTimestamp = userData["createdAt"] as? Timestamp {
                    let createdAtDate = createdAtTimestamp.dateValue()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let createdAtString = dateFormatter.string(from: createdAtDate)
                    print("사용자 생성일자: \(createdAtString)")
                }
            } else {
                print("사용자 정보가 없습니다.")
            }
        }
    }
    
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        
        do {
            try Auth.auth().signOut()
            self.state = .loggedOut // 로그아웃 상태로 변경
            
        } catch {
            print("로그아웃 중 오류 발생:", error.localizedDescription)
        }
    }
    
    // 이메일(식별자) 중복 체크
    func checkEmailDuplication(_ email: String, excludingIdentifier identifier: String? = nil, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let query = db.collection("User").whereField("emailEqualToAuth", isEqualTo: email)
        
        query.getDocuments { snapshot, error in
            if let error = error {
                print("Error checking email duplication: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            if let snapshot = snapshot, !snapshot.isEmpty {
                // 검색된 문서 중에서 식별자가 일치하지 않는 문서만 고려
                let documents = snapshot.documents.filter { document in
                    return identifier == nil || document.documentID != identifier
                }
                
                if !documents.isEmpty {
                    // 제외된 식별자를 제외하고 사용 중인 이메일이 존재
                    completion(false)
                } else {
                    // 사용 가능한 이메일
                    completion(true)
                }
            } else {
                // 사용 가능한 이메일
                completion(true)
            }
        }
    }

    // 닉네임 중복 체크
    func checkNicknameDuplication(_ nickname: String, excludingIdentifier identifier: String? = nil, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let query = db.collection("User").whereField("nickname", isEqualTo: nickname)
        
        query.getDocuments { snapshot, error in
            if let error = error {
                print("Error checking nickname duplication: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            if let snapshot = snapshot {
                let documents = snapshot.documents.filter { document in
                    return identifier == nil || document.documentID != identifier
                }
                
                if !documents.isEmpty {
                    // 제외된 식별자를 제외하고 중복된 닉네임이 존재
                    completion(false)
                } else {
                    // 중복된 닉네임이 존재하지 않음
                    completion(true)
                }
            } else {
                // 중복된 닉네임이 존재하지 않음
                completion(true)
            }
        }
    }
    
    func sendEmailVerification(newEmail: String, completion: @escaping (Bool) -> Void) {
        guard let user = currentUser else {
            print("No user is signed in.")
            completion(false)
            return
        }
        
        // 정상 작동하지 않음
        user.updateEmail(to: newEmail) { error in
            if let error = error {
                completion(false)
            } else {
                completion(true)
            }
        }
        
        // 정상 작동하지 않음
//        user.sendEmailVerification(beforeUpdatingEmail: newEmail, completion: { error in
//            if let error = error {
//                print("Error sending verification email: \(error.localizedDescription)")
//                completion(false)
//            } else {
//                print("Verification email sent successfully to \(newEmail)")
//                completion(true)
//            }
//        })
    }

    func updateUserPassword(newPassword: String, completion: @escaping (Bool) -> Void) {
        currentUser?.updatePassword(to: newPassword) { error in
            if let error = error {
                print("Error updating password: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Password updated successfully")
                completion(true)
            }
        }
    }
}

