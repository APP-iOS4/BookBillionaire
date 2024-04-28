//
//  UserService.swift
//  BookBillionaireUser
//
//  Created by YUJIN JEON on 4/4/24.
//

import Foundation
import FirebaseFirestore
import BookBillionaireCore
import FirebaseStorage

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
    
    // 유저의 myBooks 배열에서 특정 책 ID를 제거하는 함수
    func removeBookFromUser(userID: String, bookID: String) async {
        let userRef = allUserRef.document(userID)
        do {
            try await userRef.updateData([
                "myBooks" : FieldValue.arrayRemove([bookID])
            ])
            print("책 ID 제거 성공🧚‍♀️")
        } catch let error {
            print("\(#function) 유저정보에서 책 ID를 제거하는 걸 실패했음☄️ \(error)")
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
    
    // 특정 다른 사용자들의 정보를 참조 하려면 document(userID)로 다른 유저들의 상태 업데이트
    // 로그인한 사용자(예: 프로필 같이 내 정보)의 상태를 업데이트 하려면 document(currentUser.id)로 바꿔서 사용하시길
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
            print("즐겨찾기 업데이트 실패: \(error)")
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
            print("즐겨찾기 상태 여부 받아오기 실패: \(error)")
            return false
        }
    }
    
    func getFavoriteBooksCount(userID: String) async -> Int {
        let userRef = allUserRef.document(currentUser.id)
        do {
            let userData = try await userRef.getDocument()
            if let favorites = userData["favorite"] as? [String] {
                return favorites.count
            } else {
                return 0
            }
        } catch {
            print("즐겨찾기 개수 가져오기 실패: \(error)")
            return 0
        }
    }
    
    func getFavoriteBooksImages(userID: String) async -> [String: URL] {
        var images: [String: URL] = [:]
        let userRef = allUserRef.document(currentUser.id)
        let booksRef = Firestore.firestore().collection("books") // 책 정보를 저장하는 데이터베이스
        do {
            let userData = try await userRef.getDocument()
            if let favorites = userData["favorite"] as? [String] {
                for bookID in favorites {
                    let bookData = try await booksRef.document(bookID).getDocument()
                    if let thumbnail = bookData["thumbnail"] as? String {
                        if thumbnail.hasPrefix("http://") || thumbnail.hasPrefix("https://") {
                            images[bookID] = URL(string: thumbnail)
                        } else {
                            // Firebase Storage 경로 URL 다운로드
                            let storageRef = Storage.storage().reference(withPath: thumbnail)
                            let url = try await storageRef.downloadURL()
                            images[bookID] = url
                        }
                    }
                }
            }
        } catch {
            print("책 이미지 불러오기 실패: \(error)")
        }
        return images
    }
    

    func getMyBookCount(userID: String) async -> Int {
        let userRef = allUserRef.document(currentUser.id)
        do {
            let userData = try await userRef.getDocument()
            // "myBooks" 필드를 가져와서 해당 필드가 배열인지 확인 후 카운트
            if let myBooks = userData["myBooks"] as? [String] {
                return myBooks.count
            } else {
                return 0
            }
        } catch {
            print("보유한 도서의 수를 받아오는데 실패: \(error)")
            return 0
        }
    }


}


