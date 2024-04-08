//
//  AddRoomViewModel.swift
//  BookBillionaireUser
//
//  Created by 최준영 on 4/8/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

// 임시 테스트용 입니다

class AddRoomViewModel: ObservableObject {
    
    var name: String = ""
    var description: String = ""
    let db = Firestore.firestore()
    
    func createRoom(completion: @escaping () -> Void) {
        
        let room = Room(name: name, description: description)
        
        do {
        
        _ = try db.collection("chat")
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
