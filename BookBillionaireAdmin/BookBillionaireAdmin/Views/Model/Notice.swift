//
//  Notice.swift
//  BookBillionaireAdmin
//
//  Created by YUJIN JEON on 4/24/24.
//

import Foundation

struct Notice : Identifiable, Codable {
    var id: String
    var title: String
    var content: String
    var image: String?
    var createAt: Date
    
    init(title: String, content: String) {
        self.id = UUID().uuidString
        self.title = title
        self.content = content
        self.createAt = Date()
    }
}

