//
//  AuthViewModel.swift
//  BookBillionaireUser
//
//  Created by Seungjae Yu on 3/25/24.
//  참조: https://elisha0103.tistory.com/10

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import AuthenticationServices

class AuthViewModel: ObservableObject { 
    
    @Published var state: SignInState = .logOut

    enum SignInState{
        case logIn
        case logOut
    }
    
    func emailAuthSignUp(email: String, userName: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("error: \(error.localizedDescription)")
                return
            }
            
            if let result = result {
                let changeRequest = result.user.createProfileChangeRequest()
                changeRequest.displayName = userName
                changeRequest.commitChanges { error in
                    if let error = error {
                        print("Error updating profile: \(error.localizedDescription)")
                        return
                    }
                    
                    // Firestore에 사용자 정보 및 생성일자 저장
                    let db = Firestore.firestore()
                    let userData: [String: Any] = [
                        "nickname": userName,
                        "createdAt": Timestamp(date: Date()), // 현재 시간을 Timestamp로 변환하여 저장
                        "id": result.user.uid,
                        "introduction": "",
                        "profileImage": "person.crop.circle"
                    ]
                    db.collection("User").document(result.user.uid).setData(userData) { error in
                        if let error = error {
                            print("Error saving user data: \(error.localizedDescription)")
                            return
                        }
                        print("사용자 데이터가 성공적으로 저장되었습니다.")
                        
                        // 사용자 데이터를 다시 읽어와서 출력
                        self.readUserData(uid: result.user.uid)
                    }
                }
            }
        }
    }
    
    func emailAuthLogIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("error: \(error.localizedDescription)")
                
                return
            }
            
            if result != nil {
                self.state = .logIn
                print("사용자 이메일: \(String(describing: result?.user.email))")
                print("사용자 이름: \(String(describing: result?.user.displayName))") //nil 리턴
            } else {

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
    
}
