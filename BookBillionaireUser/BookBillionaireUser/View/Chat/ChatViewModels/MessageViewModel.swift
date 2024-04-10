//
//  MessageListViewModel.swift
//  BookBillionaireUser
//
//  Created by 최준영 on 4/7/24.
//

import BookBillionaireCore
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

//struct MessageViewModel {
//    
//    let message: Message
//    
//    var messageText: String {
//        message.text
//    }
//    
//    var username: String {
//        message.userId
//    }
//    
//    var messageId: String {
//        message.id ?? ""
//    }
//    
//    var messageCreatedAt: Date {
//        message.createdAt
//    }
//}

class MessageViewModel: ObservableObject {
    
    let db = Firestore.firestore()
    @Published var messages: [Message] = []
    
    func registerUpdatesForRoom(room: ChatRoom) {
        
        db.collection("chat")
            .document(room.id)
            .collection("messages")
            .order(by: "createdAt", descending: false)
            .addSnapshotListener { (snapshot, error) in
                if let error = error {
                    print("채팅 메세지 데이터 불러오기 실패")
                } else {
                    if let snapshot = snapshot {
                        
                        let messages: [Message] = snapshot.documents.compactMap { doc in
                            guard var message: Message = try? doc.data(as: Message.self) else { return }
                            message.id = doc.documentID
                            return Message(message: message)
                        }
                        
                        DispatchQueue.main.async {
                            self.messages = messages
                        }
                        
                    }
                }
            }
    }
    
    func sendMessage(msg: Message) {
        let message = msg
        
        do {
            _ = try db.collection("chat")
                .document(msg.roomId)
                .collection("messages")
                .addDocument(from: message, encoder: Firestore.Encoder()) { (error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                    }
                }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
