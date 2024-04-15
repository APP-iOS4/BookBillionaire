//
//  AddRoomViewModel.swift
//  BookBillionaireUser
//
//  Created by 최준영 on 4/8/24.
//

import BookBillionaireCore
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

// [임시] 방 생성 뷰모델 입니다 - 추후 삭제 예정

class AddRoomViewModel: ObservableObject {
    
    var name: String = ""
    let db = Firestore.firestore().collection("chat")
    
    
    func createRoom(completion: @escaping () -> Void) {
        // 채팅방 생성 함수
        let user: String = String(AuthViewModel.shared.currentUser?.uid ?? "")
        let room = Room(receiverId: name, lastTimeStamp: Date(), lastMessage: "대화를 시작해보세요!", users: [user])
        
        do {
        
        _ = try db
            .addDocument(from: room, encoder: Firestore.Encoder()) { (error) in
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

