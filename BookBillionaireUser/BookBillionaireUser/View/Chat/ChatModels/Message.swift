//
//  Message.swift
//  BookBillionaireUser
//
//  Created by 최준영 on 4/7/24.
//

import Foundation

struct Message: Codable {
    var id: String?
    var message: String       // 메세지 텍스트
    var username: String      // 해당 메세지를 보낸 유저 닉네임
    var roomId: String        // 방의 Id
    var timestamp: Date       // 메세지를 보낸 시간
}


