//
//  File.swift
//  
//
//  Created by YUJIN JEON on 3/26/24.
//

import Foundation

struct Point: Identifiable, Codable {
    var id: String
    let pointValue: Int
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.pointValue = try container.decode(Int.self, forKey: .pointValue)
    }
    
}
