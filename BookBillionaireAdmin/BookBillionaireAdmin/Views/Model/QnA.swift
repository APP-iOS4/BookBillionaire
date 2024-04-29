//
//  QnA.swift
//  BookBillionaireAdmin
//
//  Created by YUJIN JEON on 4/16/24.
//

import Foundation

struct QnA : Identifiable, Codable {
    var id: String
    var title: String
    var content: String
    var createAt: Date
    
    init(title: String, content: String) {
        self.id = UUID().uuidString
        self.title = title
        self.content = content
        self.createAt = Date()
    }
}

