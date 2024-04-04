//
//  ChatViewModel.swift
//  BookBillionaireUser
//
//  Created by 최준영 on 4/4/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ChatViewModel: Identifiable, Codable {
    // 임시로 모델 넣어둠
    // 모델 확정 후 뷰 모델 짤 예정
    var id: UUID = UUID()
    let message: String
    //var received: Bool
    var timestamp: Date
}
