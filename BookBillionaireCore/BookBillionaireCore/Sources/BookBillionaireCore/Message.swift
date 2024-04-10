//
//  File.swift
//  
//
//  Created by 최준영 on 4/10/24.
//

import Foundation

public struct Room: Identifiable {                   // 채팅방
    public var id: String = UUID().uuidString        // 채팅방의 id
    public var users: [User]                         // 채팅 방 참가 인원의 UUID
    public let latestMessage: [LatestMessageInChat]  // 최신 메세지 [최신 메세지 텍스트, 시간]
    public var usersUnreadCount: [String: Int]       // 읽지 않은 메세지 숫자 [유저Id : 읽지 않은 숫자]
}

public struct LatestMessageInChat: Hashable {        // 최신 메세지 [최신 메세지, 시간]
    public var createdAt: Date?                      // 메세지 시간
    public var text: String?                         // 메세지 텍스트
}

public struct Message: Codable, Hashable {           // 메세지
    public var id: String?                           // 메세지 id
    public var userId: String                        // 발신자 유저 id
    public var text: String                          // 메세지 텍스트
    public var createdAt: Date                       // 메세지를 보낸 시간
}
