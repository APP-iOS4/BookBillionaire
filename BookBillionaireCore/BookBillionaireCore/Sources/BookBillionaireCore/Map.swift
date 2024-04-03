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
}
