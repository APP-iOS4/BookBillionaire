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
import FirebaseStorage

struct MessageViewModel { // 수정 예정
    
    let message: Message
    
    var messageText: String {
        message.message
    }
    
    var username: String {
        message.senderId
    }
    
    var messageId: String {
        message.id ?? ""
    }
    
    var messageTimestamp: Date {
        message.timestamp
    }
    
    func formatTimestamp(_ timestamp: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a h:mm"
        return dateFormatter.string(from: timestamp)
    }
}

class MessageListViewModel: ObservableObject {
    
    let chatDB = Firestore.firestore().collection("chat")
    @Published var messages: [MessageViewModel] = []
    
    /// 채팅방 정보 변경 감지 메서드
    func registerUpdatesForRoom(room: RoomViewModel) {
        chatDB
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
    
    /// 메세지 보내기 메서드
    func sendMessage(msg: Message, completion: @escaping () -> Void) {
        
        let message = msg

        do {
            try chatDB
                .document(message.roomId)
                .collection("messages")
                .addDocument(from: message, encoder: Firestore.Encoder())
        } catch let error {
            print("\(#function) room 저장 함수 오류: \(error)")
        }
        
        do {
            chatDB
                .document(msg.roomId)
                .updateData([
                "lastMessage" : msg.message,
                "lastTimeStamp": msg.timestamp,
                "senderId": msg.senderId
                // "receiverId": msg
            ])
            print("메세지 등록 성공🧚‍♀️")
            //        } catch let error {
            //            print("\(#function) 마지막 변경 실패했음☄️ \(error)")
            //        }
        }
    }
    
    /// 채팅방 삭제 메서드
    func deleteRoom(roomID: String, completion: @escaping () -> Void) {
        chatDB
            .document(roomID)
            .delete { error in
            if let error = error {
                print("채팅방 삭제 실패: \(error)")
            } else {
                print("채팅방 삭제 성공🎉")
                completion()
            }
        }
    }
    
    /// 채팅방 안의 메세지 전체 삭제 메서드
    func deleteAllMessagesInRoom(roomID: String, completion: @escaping (Bool, Error?) -> Void) {
        let chatDB = Firestore
            .firestore()
            .collection("chat")
        chatDB
            .document(roomID)
            .collection("messages")
            .getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else {
                completion(false, error)
                return
            }
            
            let batch = Firestore
                    .firestore()
                    .batch()
            snapshot.documents.forEach { document in
                batch.deleteDocument(document.reference)
            }
            
            batch.commit { err in
                if let err = err {
                    print("채팅방 안의 메세지 삭제 실패: \(err)")
                    completion(false, err)
                } else {
                    print("채팅방 안의 모든 메세지 삭제 성공🎉")
                    completion(true, nil)
                }
            }
        }
    }
    
    /// 채팅방 사진 업로드 메서드
    func uploadPhoto(selectedImage: UIImage?, photoImage: String) {
        guard selectedImage != nil else {
            return
        }
        let storageRef = Storage.storage().reference()
        let imageData = selectedImage!.jpegData(compressionQuality: 0.8)
        guard imageData != nil else {
            return
        }
        let path = "chatImages/\(UUID().uuidString).jpg"
        _ = path
        let fileRef = storageRef.child(path)
        _ = fileRef.putData(imageData!, metadata: nil) { metadata, error in
            if error == nil && metadata != nil {
            }
        }
    }
}
