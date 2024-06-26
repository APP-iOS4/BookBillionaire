//
//  RoomListViewModel.swift
//  BookBillionaireUser
//
//  Created by 최준영 on 4/7/24.
//

//import BookBillionaireCore
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

class RoomListViewModel: ObservableObject {
    
    @Published var rooms: [RoomViewModel] = []
    let db = Firestore.firestore().collection("chat")
    
    var receiverName: String = "임시 이름"
    var receiverId: String = "임시 Id"
    var roomId: String = "임시 roomId"
    
    // [임시] 채팅방 목록을 불러오는 함수 - 추후 로그인 Id에 맞춰서 array-contains 사용하여 필터링 하여 가져와야함
    
    func getAllRooms() {
        db.order(by: "lastTimeStamp", descending: true)
            .getDocuments { (snapshot, error) in
                // async await 공식 문서 찾아보기
                // weak 약한 참조 문서도 확인해보기
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
                    completion(nil) // 에러가 발생하면 nil 반환
                } else {
                    print("방 생성 \(user) with ID: \(room.id)")
                    self.roomId = room.id
                    completion(room.id) // 성공적으로 생성되면 문서 ID 반환
                }
            }
        } catch let error {
            print(error.localizedDescription)
            completion(nil) // 예외 발생 시 nil 반환
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

