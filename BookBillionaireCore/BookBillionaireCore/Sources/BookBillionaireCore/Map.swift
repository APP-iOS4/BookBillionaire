//
//  File.swift
//  
//
//  Created by YUJIN JEON on 3/21/24.
//

import Foundation

public struct Map: Identifiable, Codable {
    public var id: String
    public var latitude: Double
    public var longitude: Double
    
    public init(latitude: Double, longitude: Double) {
        self.id = UUID().uuidString
        self.latitude = latitude
        self.longitude = longitude
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: MapCodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.latitude = try container.decode(Double.self, forKey: .latitude)
        self.longitude = try container.decode(Double.self, forKey: .longitude)
    }
}

/// 코딩키
public enum MapCodingKeys: String, CodingKey {
    case id, latitude, longitude
}

