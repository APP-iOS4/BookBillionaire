//
//  MessageListViewModel.swift
//  BookBillionaireUser
//
//  Created by 최준영 on 4/7/24.
//

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
        message.senderName
    }
    
    var messageId: String {
        message.id ?? ""
    }
    
    var messageTimestamp: Date {
        message.timestamp
    }
    
    var imageUrl: URL? {
        message.imageUrl
    }
    
    func formatTimestamp(_ timestamp: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a h:mm"
        return dateFormatter.string(from: timestamp)
    }
}

class ChatViewModel: ObservableObject {
    
    let chatDB = Firestore.firestore().collection("chat")
    @Published var messages: [MessageViewModel] = []
    var lastDoc: QueryDocumentSnapshot?
    var shouldScrollToBottom = true // 스크롤 하단 맞춤 제어를 위한 상태 변수
    
      // 채팅방 정보 변경 감지 및 최초 메세지 불러오기 메서드
      func registerUpdatesForRoom(room: RoomViewModel, pageSize: Int) {
          chatDB
              .document(room.roomId)
              .collection("messages")
              .order(by: "timestamp", descending: true)
              .limit(to: pageSize)
              .addSnapshotListener { [weak self] (snapshot, error) in
                  guard let self = self else { return }
                  if let error = error {
                      print(error.localizedDescription)
                  } else {
                      if let snapshot = snapshot {
                          var messages: [MessageViewModel] = snapshot.documents.compactMap { doc in
                              guard var message: Message = try? doc.data(as: Message.self) else { return nil }
                              message.id = doc.documentID
                              return MessageViewModel(message: message)
                          }
                          messages.reverse()
                          DispatchQueue.main.async {
                              self.messages = messages
                              self.lastDoc = snapshot.documents.last
                          }
                      }
                  }
                  self.lastDoc = snapshot?.documents.last
              }
      }

      /// 추가 채팅 페이지네이션 메서드
    func loadMoreChat(room: RoomViewModel, pageSize: Int) {
        guard let lastDoc = self.lastDoc else { return } // 마지막 문서 체크

        chatDB
            .document(room.roomId)
            .collection("messages")
            .order(by: "timestamp", descending: true)
            .limit(to: pageSize)
            .start(afterDocument: lastDoc) // 마지막 문서 기준으로 이전 메시지 검색
            .getDocuments { [weak self] (snapshot, error) in
                guard let self = self else { return }
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    if let snapshot = snapshot {
                        var newMessages: [MessageViewModel] = snapshot.documents.compactMap { doc in
                            guard var message: Message = try? doc.data(as: Message.self) else { return nil }
                            message.id = doc.documentID
                            return MessageViewModel(message: message)
                        }
                        newMessages.reverse() // 불러온 메시지 순서 뒤집기
                        
                        // 기존 메시지 배열에 새로운 메시지 추가
                        self.messages.insert(contentsOf: newMessages, at: 0)
                        self.lastDoc = snapshot.documents.last // 새로운 마지막 문서 업데이트
                    }
                }
            }
    }
    
    /// 메세지 등록 메서드
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
                "senderName": msg.senderName
            ])
            print("메세지 등록 성공🧚‍♀️")
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
    
    /// Storage에 이미지 업로드 하는 메서드
    func uploadPhoto(selectedImage: UIImage?, completion: @escaping (URL?) -> Void) {
        guard let selectedImage = selectedImage else {
            completion(nil)
            return
        }
        
        let storageRef = Storage.storage().reference()
        let imageData = selectedImage.jpegData(compressionQuality: 1)
        
        guard let imageData = imageData else {
            completion(nil)
            return
        }
        
        let path = "chatImages/\(UUID().uuidString).jpg"
        let fileRef = storageRef.child(path)
        
        // 이미지 업로드
        _ = fileRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error)")
                completion(nil)
            } else {
                // 업로드가 성공하면 fetchDownloadURL()을 호출하여 다운로드 URL 가져오기
                self.fetchDownloadURL(for: path, completion: completion)
            }
        }
    }
    
    ///Storage에 올라간 사진을 URL로 변환하는 메서드
    func fetchDownloadURL(for path: String, completion: @escaping (URL?) -> Void) {
        let storageRef = Storage.storage().reference()
        let fileRef = storageRef.child(path)
        
        // 다운로드 URL 가져오기
        fileRef.downloadURL { url, error in
            if let error = error {
                print("Error getting download URL: \(error)")
                completion(nil) // 에러가 발생하면 nil을 반환
            } else if let url = url {
                // 다운로드 URL이 성공적으로 얻어졌을 때 반환
                completion(url)
            }
        }
    }
}
