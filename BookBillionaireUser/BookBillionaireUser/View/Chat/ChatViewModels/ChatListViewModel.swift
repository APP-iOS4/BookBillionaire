//
//  RoomListViewModel.swift
//  BookBillionaireUser
//
//  Created by 최준영 on 4/7/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import BookBillionaireCore

struct RoomViewModel: Hashable { // 수정 예정
    
    var room: ChatRoom
    
    var receiverName: String {
        room.receiverName
    }
    
    var roomId: String {
        room.id
    }
    
    var lastTimeStamp: Date {
        room.lastTimeStamp
    }
    
    var lastMessage: String {
        room.lastMessage ?? ""
    }
    
    var users: [String] {
        room.users
    }
    
    var usersUnreadCountInfo: [String: Int]? {
        room.usersUnreadCountInfo
    }
}

class ChatListViewModel: ObservableObject {
    
    @Published var rooms: [RoomViewModel] = []
    let db = Firestore.firestore()
    
    var receiverName: String = "임시 이름"
    var receiverId: String = "임시 Id"
    var roomId: String = "임시 roomId"
    
    let userId = AuthViewModel.shared.currentUser?.uid ?? ""
    
    /// 유저가 포함된 채팅방의 목록을 불러오는 메서드
    func getAllRooms() {
        let userId = AuthViewModel.shared.currentUser?.uid ?? ""
        // 현재 로그인한 사용자의 ID
        
        print("본인 유저 아이디 : \(userId)")
        db.collection("chat").whereField("users", arrayContains: userId)
            .order(by: "lastTimeStamp", descending: true)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    if let snapshot = snapshot {
                        let rooms: [RoomViewModel] = snapshot.documents.compactMap { doc in
                            guard var room = try? doc.data(as: ChatRoom.self) else {
                                return nil
                            }
                            room.id = doc.documentID
                            return RoomViewModel(room: room)
                        }
                        self.rooms = rooms
                    }
                }
            }
    }
    
    /// 채팅방 생성 메서드
    func createRoom(book: Book, completion: @escaping (String?) -> Void) {
        let receiverId = book.ownerID
        
        // 수신자 id, 발신자 id, 빌릴 책의 id 3개가 모두 동일하다면 방 생성 불가
        db.collection("chat")
            .whereField("users", isEqualTo: [userId, receiverId])
            .whereField("book.id", isEqualTo: book.id)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("중복된 수신자와 책 정보를 확인하는데 오류 발생: \(error)")
                    completion(nil)
                } else {
                    if let snapshot = snapshot, !snapshot.isEmpty {
                        if let roomId = snapshot.documents.first?.documentID {
                            print("해당 수신자와 책 정보가 일치하는 채팅방이 이미 존재함")
                            print("기존의 채팅방 ID: \(roomId)")
                            completion(roomId)
                        } else {
                            print("중복된 수신자와 책 정보가 존재하지만 채팅방 ID를 찾을 수 없음")
                            completion("중복된 채팅방 ID를 찾을 수 없음")
                        }
                    } else {
                        var room = ChatRoom(receiverName: self.receiverName, lastTimeStamp: Date(), lastMessage: "대화를 시작해보세요!", users: [self.userId, receiverId], usersUnreadCountInfo: [:], book: book)
                        let newRoomRef = self.db.collection("chat").document()
                        room.id = newRoomRef.documentID
                        
                        do {
                            try newRoomRef.setData(from: room, encoder: Firestore.Encoder()) { (error) in
                                if let error = error {
                                    print("문서 생성 중 에러 발생: \(error)")
                                    completion(nil)
                                } else {
                                    print("새로운 문서 생성 완료 - 방 ID: \(room.id)")
                                    print("본인 아이디: \(self.userId), 상대방 아이디: \(receiverId), 책 ID: \(book.id)")
                                    completion(room.id)
                                }
                            }
                        } catch {
                            print("문서 생성 중 에러 발생: \(error)")
                            completion(nil)
                        }
                    }
                }
            }
    }

    
//    /// 채팅방 생성 메서드 (중복 채팅방 생성 가능)
//    func createRoom(book: Book, completion: @escaping (String?) -> Void) {
//        let receiverId = book.ownerID
//        
//        // 새로운 채팅방 생성
//        var room = ChatRoom(receiverName: self.receiverName, lastTimeStamp: Date(), lastMessage: "대화를 시작해보세요!", users: [self.userId, receiverId], usersUnreadCountInfo: [:], book: book)
//        let newRoomRef = self.db.document()
//        room.id = newRoomRef.documentID
//        
//        do {
//            try newRoomRef.setData(from: room, encoder: Firestore.Encoder()) { (error) in
//                if let error = error {
//                    print("문서 생성 중 에러 발생: \(error)")
//                    completion(nil)
//                } else {
//                    print("새로운 문서 생성 완료 - 방 ID: \(room.id)")
//                    print("본인 아이디: \(self.userId), 상대방 아이디: \(receiverId)")
//                    completion(room.id)
//                }
//            }
//        } catch {
//            print("문서 생성 중 에러 발생: \(error)")
//            completion(nil)
//        }
//    }
    
//    /// 채팅방 생성 메서드 (중복 채팅방 생성 불가)
//    func createRoom(book: Book, completion: @escaping (String?) -> Void) {
//        let receiverId = book.ownerID
//        
//        // 기존 채팅방 조회
//        db.whereField("users", isEqualTo: [userId, receiverId])
//            .getDocuments { (snapshot, error) in
//                if error != nil {
//                    print("중복된 수신자를 확인하는데 오류")
//                } else {
//                    if let snapshot = snapshot, !snapshot.isEmpty {
//                        if let roomId = snapshot.documents.first?.documentID {
//                            print("해당 수신자와의 채팅방이 이미 존재함")
//                            print("기존의 채팅방 \(roomId)")
//                            completion(roomId)
//                        } else {
//                            print("중복된 수신자가 존재하지만 채팅방 ID를 찾을 수 없음")
//                            completion("중복된 채팅방 ID를 찾을 수 없음")
//                        }
//                    } else {
//                        var room = ChatRoom(receiverName: self.receiverName, lastTimeStamp: Date(), lastMessage: "대화를 시작해보세요!", users: [self.userId, receiverId], usersUnreadCountInfo: [:], book: book)
//                        let newRoomRef = self.db.document()
//                        room.id = newRoomRef.documentID
//                        
//                        do {
//                            try newRoomRef.setData(from: room, encoder: Firestore.Encoder()) { (error) in
//                                if error != nil {
//                                    print("문서 생성 중 에러 발생")
//                                } else {
//                                    print("새로운 문서 생성 완료 - 방 ID: \(room.id)")
//                                    print("본인 아이디: \(self.userId), 상대방 아이디: \(receiverId)")
//                                    completion(room.id)
//                                }
//                            }
//                        } catch _ {
//                            print("문서 생성 중 에러 발생")
//                        }
//                    }
//                }
//            }
//    }
    
    func updateUnreadMessageCount(roomId: String, count: Int) {
        guard let currentUserID = AuthViewModel.shared.currentUser?.uid else {
            print("현재 사용자 ID를 가져올 수 없습니다.")
            return
        }
        
        db.document(roomId).updateData([
            "usersUnreadCountInfo.\(currentUserID)": count
        ]) { error in
            if let error = error {
                print("읽지 않은 메시지 수 업데이트 중 에러 발생: \(error.localizedDescription)")
            } else {
                print("읽지 않은 메시지 수 업데이트 완료")
            }
        }
    }
    
    /// 안 읽은 메시지 숫자를 반환하는 메서드
    func unreadMessageCount(for userId: String) -> Int {
        if let room = rooms.first(where: { $0.room.users.contains(userId) }) {
            return room.usersUnreadCountInfo?[userId] ?? 0
        } else {
            return 0
        }
    }
    
    /// Promise 컬렉션 약속 일정 저장하기
    func createPromise(booktitle: String, bookId: String, ownerId: String, senderId: String, createAt: Date, selectedTime: Date, selectedDate: Date) {
        let promiseRef = db.collection("promises").document()
        
        let promise: [String: Any] = [
            "booktitle": booktitle,
            "bookId": bookId,
            "users": [ownerId, senderId],
            "createAt": createAt,
            "promiseDate": selectedDate,
            "promiseTime": selectedTime
        ]
        
        promiseRef.setData(promise) { (error) in
            if error != nil {
                print("Promise 문서 생성 중 오류 발생")
            } else {
                print("Promise 문서 생성 완료")
            }
        }
    }
    
    /// Complain 컬렉션 보내기
    func addComplaint(bookId: String, ownerId: String, senderId: String, createAt: Date, reason: String) {
        let complainRef = db.collection("complain").document()
        
        let data: [String: Any] = [
            "bookId": bookId,
            "users": [ownerId, senderId],
            "createAt": createAt,
            "reason": reason
        ]
        
        complainRef.setData(data) { error in
            if error != nil {
                print("Complain 문서 생성 중 오류 발생")
            } else {
                print("Complain 문서 생성 완료")
            }
        }
    }

    /// book.Id로 좌표를 불러오는 메서드
    func fetchLatLongForBookId(_ bookId: String, completion: @escaping (Double?, Double?) -> Void) {
        let db = Firestore.firestore()
        db.collection("rentals")
            .whereField("bookID", isEqualTo: bookId)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("불러오기 실패")
                    return
                }
                
                guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                    return
                }
                
                if let latitude = documents.first?.data()["latitude"] as? Double,
                   let longitude = documents.first?.data()["longitude"] as? Double {
                    completion(latitude, longitude)
                } else {
                }
            }
    }
}
