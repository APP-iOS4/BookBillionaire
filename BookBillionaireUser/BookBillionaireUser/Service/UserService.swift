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
    @Published var users: [User] = []
    @Published var currentUser: User = User()
    private let allUserRef = Firestore.firestore().collection("User")
    
    /// 모든 유저들의 정보를 가져오는 함수
    func loadUsers() async {
        do {
            let querySnapshot = try await allUserRef.getDocuments()
            self.users = querySnapshot.documents.compactMap { document -> User? in
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
    func loadUserByID(_ UserID: String) -> User {
        return users.filter { $0.id == UserID }.first ?? User()
    }
    
    // 책 소유자 전체 유저 데이터 호출
    func fetchUsers() {
        Task {
            await self.loadUsers()
        }
    }
    
    func updateUserByID(_ userID: String, nickname: String, imageUrl: String, address: String) async {
        let userRef = allUserRef.document(userID)
        do {
            try await userRef.updateData([
                "nickname": nickname,
                "profileImage": imageUrl,
                "address": address
            ])
            print("유저 정보 변경 성공")
        } catch let error {
            print("Error updating user: \(error)")
        }
    }
   
    func toggleFavoriteStatus(bookID: String) async -> Bool? {
        let userRef = allUserRef.document(currentUser.id)
        do {
            let userData = try await userRef.getDocument()
            // "favorite" 필드를 가져와서 해당 필드가 배열인지 확인
            if var favorites = userData["favorite"] as? [String] {
                if favorites.contains(bookID) {
                    favorites.removeAll { $0 == bookID }
                    try await userRef.updateData(["favorite": favorites])
                    print("즐겨찾기 해제 성공")
                    return false
                    
                } else {
                    try await userRef.updateData([
                        "favorite": FieldValue.arrayUnion([bookID])
                    ])
                    print("즐겨찾기 등록 성공")
                    return true
                }
                
            } else {
                try await userRef.updateData([
                    "favorite": [bookID]
                ])
                print("즐겨찾기 등록 성공")
                return true
            }
            
        } catch let error {
            print("Error updating user: \(error)")
            return nil
        }
    }
  
    func checkFavoriteStatus(bookID: String) async -> Bool {
        let userRef = allUserRef.document(currentUser.id)
        do {
            let userData = try await userRef.getDocument()
            // "favorite" 필드를 가져와서 해당 필드가 배열인지 확인
            if let favorites = userData["favorite"] as? [String] {
                return favorites.contains(bookID)
            } else {
                return false
            }
        } catch {
            print("Error checking favorite status: \(error)")
            return false
        }
    }

}
