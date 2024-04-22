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
}

class ChatListViewModel: ObservableObject {
    
    @Published var rooms: [RoomViewModel] = []
    let db = Firestore.firestore().collection("chat")
    
    var receiverName: String = "임시 이름"
    var receiverId: String = "임시 Id"
    var roomId: String = "임시 roomId"
    
    /// 유저가 포함된 채팅방의 목록을 불러오는 메서드
    func getAllRooms(userId: String) {
        print("방을 생성한 유저 아이디 : \(userId)")
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
        
        let user: String = String(AuthViewModel.shared.currentUser?.uid ?? "")
        var room = ChatRoom(receiverName: receiverName, lastTimeStamp: Date(), lastMessage: "대화를 시작해보세요!", users: [user, receiverId])
        
        let newRoomRef = db.document()
        room.id = newRoomRef.documentID
        
        do {
            try newRoomRef.setData(from: room, encoder: Firestore.Encoder()) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                    completion(nil)
                } else {
                    print("방 생성 \(user) with ID: \(room.id)")
                    self.roomId = room.id
                    completion(room.id)
                }
            }
        } catch let error {
            print(error.localizedDescription)
            completion(nil)
        }
    }
    
    /// 이미 있는 방을 찾는 메서드
    func findExistingRoom(completion: @escaping (String?) -> Void) {
        let user: String = String(AuthViewModel.shared.currentUser?.uid ?? "")
        
        // users 필드에 현재 유저 ID가 있는 방을 조회
        db.whereField("users", arrayContains: user)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                    completion(nil)
                } else {
                    if let snapshot = snapshot {
                        // 이미 있는 방이 있다면 첫 번째 방의 ID를 반환
                        if let doc = snapshot.documents.first {
                            let roomId = doc.documentID
                            print("이미 있는 방 ID: \(roomId)")
                            completion(roomId)
                        } else {
                            // 이미 있는 방이 없으면 nil 반환
                            print("이미 있는 방이 없습니다.")
                            completion(nil)
                        }
                    }
                }
            }
    }

    /// 채팅방 생성 또는 이미 있는 방으로 이동하는 메서드
    func createOrNavigateToRoom(completion: @escaping (String?) -> Void) {
        // 이미 있는 방을 찾음
        findExistingRoom { existingRoomId in
            if let existingRoomId = existingRoomId {
                // 이미 있는 방이 있다면 해당 방 ID를 반환
                completion(existingRoomId)
            } else {
                // 이미 있는 방이 없다면 새로운 방 생성
                self.createRoom { newRoomId in
                    completion(newRoomId)
                }
            }
        }
    }

    
    ///생성된 채팅방 ID 값을 가져오는 함수
    func loadChatRoomByID(_ roomId: String) async -> ChatRoom {
        
        var room = ChatRoom(receiverName: "", lastTimeStamp: Date(), lastMessage: "", users: [])
        
        do {
            room = try await db.document(roomId).getDocument(as: ChatRoom.self)
            print("(document.documentID) => (document.data())🎉")
            print(room.id)

        } catch {
            print("Error getting documents: (error)👻")
        }
        return room
    }
}

