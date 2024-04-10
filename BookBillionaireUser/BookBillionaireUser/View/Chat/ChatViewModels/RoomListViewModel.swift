//
//  RoomListViewModel.swift
//  BookBillionaireUser
//
//  Created by 최준영 on 4/7/24.
//

import BookBillionaireCore
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct RoomViewModel {
    
    let room: ChatRoom
    
//    var users: [User] {
//        room.users
//    }
    
    var latestMessage: [LatestMessageInChat] {
        room.latestMessage
    }
    
    var roomId: String {
        room.id
    }
}

class RoomListViewModel: ObservableObject {
    
//    @Published var rooms: [ChatRoom] = []
    let db = Firestore.firestore().collection("chat")
    
    func getAllRooms() {
        // 채팅방 목록을 불러오는 함수
        db.getDocuments { (snapshot, error) in
                if let error = error {
                    print("채팅방 목록 불러오기를 실패했습니다.")
                } else {
                    if let snapshot = snapshot {
                        let rooms: [ChatRoom] = snapshot.documents.compactMap { doc in
                            guard var room = try? doc.data(as: ChatRoom) else {
                                return nil
                            }
                            
                            room.id = doc.documentID
                            return ChatRoom(room: room)
                        }
                        
                        DispatchQueue.main.async {
                            self.rooms = rooms
                        }
                    }
                }
            }
    }
}
