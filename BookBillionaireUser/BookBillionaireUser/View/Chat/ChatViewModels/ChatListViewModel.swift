//
//  RoomListViewModel.swift
//  BookBillionaireUser
//
//  Created by 최준영 on 4/7/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

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
        room.lastMessage
    }
    
//    var unreadMessageCount: Int {
//        let currentUserID = AuthViewModel.shared.currentUser?.uid ?? ""
//        return room.usersUnreadCountInfo?[currentUserID] ?? 0
//    }
}

class ChatListViewModel: ObservableObject {
    @Published var rooms: [RoomViewModel] = []
    
    let db = Firestore.firestore().collection("chat")
    
    var receiverName: String = "임시 이름"
    var receiverId: String = "임시 Id"
    var roomId: String = "임시 roomId"
    
    /// 유저가 포함된 채팅방의 목록을 불러오는 메서드
    func getAllRooms() {
        let userId = AuthViewModel.shared.currentUser?.uid ?? ""
        print("1============================\(receiverId)")
        // 현재 로그인한 사용자의 ID
        print("본인 유저 아이디 : \(userId)")
        db.whereField("users", arrayContains: userId)
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
    func createRoom(completion: @escaping (String?) -> Void) {
        guard let currentUserID = AuthViewModel.shared.currentUser?.uid else {
            print("현재 사용자 ID를 가져올 수 없습니다.")
            return
        }
        
        let receiverID = self.receiverId
        print("2============================\(receiverId)")

        db.whereField("users", arrayContains: currentUserID)
            .whereField("users", isEqualTo: receiverID)
            .getDocuments { (snapshot, error) in
                if error != nil {
                    print("중복된 수신자를 확인하는데 오류")
                } else {
                    if let snapshot = snapshot, !snapshot.isEmpty {
                        // 이미 중복된 사용자 쌍을 가진 문서가 존재함
                        print("이미 중복된 수신자가 존재함")
                    } else {
                        // 중복된 사용자 쌍이 없는 경우 새로운 문서 생성
                        var room = ChatRoom(receiverName: self.receiverName, lastTimeStamp: Date(), lastMessage: "대화를 시작해보세요!", users: [currentUserID, receiverID])
                        let newRoomRef = self.db.document()
                        room.id = newRoomRef.documentID
                        
                        do {
                            try newRoomRef.setData(from: room, encoder: Firestore.Encoder()) { (error) in
                                if error != nil {
                                    print("문서 생성 중 에러 발생 ")
                                } else {
                                    print("새로운 문서 생성 완료 - 방 ID: \(room.id)")
                                    completion(room.id)
                                }
                            }
                        } catch _ {
                            print("문서 생성 중 에러 발생")
                        }
                    }
                }
            }
    }
    
    /// 읽지 않은 메시지 수를 업데이트하는 메서드
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
}

