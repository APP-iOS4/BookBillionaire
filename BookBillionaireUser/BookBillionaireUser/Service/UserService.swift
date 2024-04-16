//
//  UserService.swift
//  BookBillionaireUser
//
//  Created by YUJIN JEON on 4/4/24.
//

import Foundation
import FirebaseFirestore
import BookBillionaireCore

class UserService: ObservableObject {
    static let shared = UserService()
    public var users: [User]
    
    private let allUserRef = Firestore.firestore().collection("User")
    
    /// 외부에서 인스턴스화 방지를 위한 private 초기화
    private init() {
        users = []
    }
    
    /// 모든 유저들의 정보를 가져오는 함수
    func loadUsers() async {
        do {
            let querySnapshot = try await allUserRef.getDocuments()
            users = querySnapshot.documents.compactMap { document -> User? in
                do {
                    let user = try document.data(as: User.self)
                    return user
                } catch {
                    print("Error decoding user: \(error)")
                    return nil
                }
            }
        } catch {
            print("Error fetching documents: \(error)")
        }
    }
    
    /// 유저의 책정보 등록(관리용)
    func setBooksToUser(userID: String, book: String) async {
        let userRef = allUserRef.document(userID)
        do {
            try await userRef.updateData([
                "myBooks" : FieldValue.arrayUnion([book])
            ])
            print("책넣기 성공🧚‍♀️")
        } catch let error {
            print("\(#function) 유저정보에 책을 넣는 걸 실패했음☄️ \(error)")
        }
    }
    
    /// 유저 ID로 유저 정보를 불러오는 함수
    func loadUserByID(_ UserID: String) async -> User {
        var user: User
        do {
            user = try await allUserRef.document(UserID).getDocument().data(as: User.self)
            print("\(user)")
            return user
        } catch {
            print("Error decoding book: \(error)")
            return User(id: "", nickName: "", address: "")
        }
    }
    
    // 책 소유자 유저 데이터 호출
    func fetchUsers() {
        Task {
            await UserService.shared.loadUsers()
        }
    }
    
    func updateUserByID(_ userID: String, nickname: String, imageUrl: String) async {
        let userRef = allUserRef.document(userID)
        do {
            try await userRef.updateData([
                "nickname": nickname,
                "profileImage": imageUrl
            ])
            print("유저 정보 변경 성공")
        } catch let error {
            print("Error updating user: \(error)")
        }
    }
}



