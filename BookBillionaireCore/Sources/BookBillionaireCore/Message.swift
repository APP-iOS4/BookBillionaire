//
//  File.swift
//  
//
//  Created by YUJIN JEON on 3/21/24.
//

import Foundation

public struct Message: Identifiable, Codable{
    public var id: String = UUID().uuidString
    public let message: String
    public var received: Bool
    public var timestamp: Date = Date()
    
    public init(message: String, received: Bool) {
        self.message = message
        self.received = received
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.message = try container.decode(String.self, forKey: .message)
        self.received = try container.decode(Bool.self, forKey: .received)
        self.timestamp = try container.decode(Date.self, forKey: .timestamp)
    }
}
