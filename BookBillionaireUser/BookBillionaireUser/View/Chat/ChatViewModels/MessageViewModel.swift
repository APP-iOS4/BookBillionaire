//
//  MessageListViewModel.swift
//  BookBillionaireUser
//
//  Created by 최준영 on 4/7/24.
//

//import BookBillionaireCore
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct MessageViewState {
    let message: String
    let roomId: String
    let username: String
    var timestamp: Date
}

struct MessageViewModel {
    
    let message: Message
    
    var messageText: String {
        message.text
    }
    
    var username: String {
        message.username
    }
    
    var messageId: String {
        message.id ?? ""
    }
}

class MessageListViewModel: ObservableObject {
    
    let db = Firestore.firestore()
    @Published var messages: [MessageViewModel] = []
    
    func registerUpdatesForRoom(room: RoomViewModel) {
        
        db.collection("chat")
            .document(room.roomId)
            .collection("messages")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { (snapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    if let snapshot = snapshot {
                        
                        let messages: [MessageViewModel] = snapshot.documents.compactMap { doc in
                            guard var message: Message = try? doc.data(as: Message.self) else { return nil }
                            message.id = doc.documentID
                            return MessageViewModel(message: message)
                        }
                        
                        DispatchQueue.main.async {
                            self.messages = messages
                        }
                    }
                }
            }
    }
    
    func sendMessage(msg: MessageViewState, completion: @escaping () -> Void) {
        
        let message = Message(vs: msg)
        
        do {
        _ = try db.collection("chat")
            .document(message.roomId)
            .collection("messages")
            .addDocument(from: message, encoder: Firestore.Encoder()) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    completion()
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
