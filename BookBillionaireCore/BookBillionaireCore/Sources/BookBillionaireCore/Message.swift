//
//  File.swift
//  
//
//  Created by 최준영 on 4/10/24.
//

import Foundation
import FirebaseFirestoreSwift

public struct ChatRoom: Identifiable, Codable {        // 채팅방
    @DocumentID public var id: String                  // 채팅방의 id
    public var sender: String
    public var receiver: String
    public var usersUnreadCount: [String: Int]         // 읽지 않은 메세지 숫자 [유저Id : 읽지 않은 숫자]
}

public struct Message: Identifiable, Codable {         // 메세지
    @DocumentID public var id: String                  // 메세지 id
    public var roomId: String                          // 메세지를 보낼 방의 id
    public var senderId: String                        // 발신자 유저 id
    public var text: String                            // 메세지 텍스트
    public var createdAt: Date                         // 메세지를 보낸 시간
}

//import Foundation
//
//struct Room: Codable, Hashable {
//    var id: String?
//    let name: String          // 방의 이름 (상대방 닉네임)
//    let description: String   // [임시] last Chat
////    let users: [String]       // 유저 2명의 userID
//}


//import Foundation
//
//struct Message: Codable {
//
//    var id: String?
//    var text: String = ""          // 메세지 텍스트
//    var username: String = ""      // 해당 메세지를 보낸 유저 닉네임
//    var roomId: String = ""        // [임시] 방의 Id
//    var timestamp: Date            // 메세지를 보낸 시간

//
//    init(vs: MessageViewState) {
//        text = vs.message
//        username = vs.username
//        roomId = vs.roomId
//        timestamp = vs.timestamp
//    }
//}
