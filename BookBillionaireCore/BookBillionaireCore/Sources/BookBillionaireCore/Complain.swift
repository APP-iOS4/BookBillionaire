//
//  File.swift
//  
//
//  Created by YUJIN JEON on 4/23/24.
//

import Foundation

public struct Complain : Identifiable, Codable {
    public var id: String
    public var to: String
    public var from: String
    public var reason: String
    
    public init() {
        self.id = UUID().uuidString
        self.to = ""
        self.from = ""
        self.reason = ""
    }
    
    public init(to: String, from: String, reason: String){
        self.id = UUID().uuidString
        self.to = to
        self.from = from
        self.reason = reason
    }
}

