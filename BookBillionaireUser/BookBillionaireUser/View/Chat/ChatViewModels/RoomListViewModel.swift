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

struct RoomViewModel: Hashable {
    
    let room: Room
    
    var receiverName: String {
        room.receiverName
    }

    var roomId: String {
        room.id ?? ""
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
    
    func getAllRooms() {
        // [임시] 채팅방 목록을 불러오는 함수 - 추후 로그인 Id에 맞춰서 array-contains 사용하여 필터링 하여 가져와야함
        db
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    if let snapshot = snapshot {
                        
                        let rooms: [RoomViewModel] = snapshot.documents.compactMap { doc in
                            guard var room = try? doc.data(as: Room.self) else {
                                return nil
                            }
                            
                            room.id = doc.documentID
                            return RoomViewModel(room: room)
                        }
                        
                        DispatchQueue.main.async {
                            self.rooms = rooms
                        }
                    }
                }
            }
    }
}
