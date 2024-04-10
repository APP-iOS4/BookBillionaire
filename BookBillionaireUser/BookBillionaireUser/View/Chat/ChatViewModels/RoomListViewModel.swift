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
    
    var name: String {
        room.name
    }
    
    var description: String {
        room.description
    }
    
    var roomId: String {
        room.id ?? ""
    }
}

class RoomListViewModel: ObservableObject {
    
    @Published var rooms: [RoomViewModel] = []
    let db = Firestore.firestore()
    
    func getAllRooms() {
        // 채팅방 목록을 불러오는 함수
        db.collection("chat")
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
