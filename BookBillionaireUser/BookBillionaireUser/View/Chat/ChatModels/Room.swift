//
//  Room.swift
//  BookBillionaireUser
//
//  Created by 최준영 on 4/7/24.
//

import Foundation

struct Room: Codable, Hashable {
    var id: String?
    let name: String          // 방의 이름 (상대방 닉네임)
    let description: String   // [임시] last Chat
//    let users: [String]       // 유저 2명의 userID
}
