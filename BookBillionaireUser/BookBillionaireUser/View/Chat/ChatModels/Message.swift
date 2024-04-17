//
//  Message.swift
//  BookBillionaireUser
//
//  Created by 최준영 on 4/7/24.
//

import Foundation

struct Message: Codable, Hashable {
    var id: String?
    var message: String        // 메세지 텍스트
    var senderName: String     // 메세지를 보낸 유저 이름
    var roomId: String         // 대화방의 Id
    var timestamp: Date        // 메세지를 보낸 시간
    var ImageURL: String?      // 사진 첨부
}


