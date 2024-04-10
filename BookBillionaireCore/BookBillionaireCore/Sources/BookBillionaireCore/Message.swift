//
//  File.swift
//  
//
//  Created by 최준영 on 4/10/24.
//

import Foundation

public struct Room: Identifiable, Codable {
    public var id: String?
    let lastMessage: String        // 마지막 메세지 (채팅방 목록 메세지 미리보기)
    let sender: String             // 발신자
    let receiver: String           // 수신자
}

public struct Message: Identifiable, Codable {
    public var id: String?
    var text: String = ""          // 메세지 텍스트
    var timestamp: Date            // 메세지를 보낸 시간
    var sender: String             // 발신자
    let receiver: String           // 수신자
}

/*
 public struct ChatRoom: Identifiable, Codable {        // 채팅방
     @DocumentID public var id: String                  // 채팅방의 id
     public var sender: String                          // 발신자
     public var receiver: String                        // 수신자
     public var usersUnreadCount: [String: Int]         // 읽지 않은 메세지 숫자 [유저Id : 읽지 않은 숫자]
 }

 public struct Message: Identifiable, Codable {         // 메세지
     @DocumentID public var id: String                  // 메세지 id
     public var roomId: String                          // 메세지를 보낼 방의 id
     public var senderId: String                        // 발신자 유저 id
     public var text: String                            // 메세지 텍스트
     public var createdAt: Date                         // 메세지를 보낸 시간
 }

 */
