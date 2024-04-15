//
//  Room.swift
//  BookBillionaireUser
//
//  Created by 최준영 on 4/7/24.
//

import Foundation

struct Room: Codable, Hashable {
    var id: String?
    let receiverId: String      // 방의 이름 (상대방 닉네임)
    let lastTimeStamp: Date     // 마지막 메세지의 시간
    let lastMessage: String     // 마지막 메세지
    let users: [String]         // [대화 참여 인원의 ID]
}
