//
//  CategoryModel.swift
//  BookBillionaireAdmin
//
//  Created by YUJIN JEON on 4/16/24.
//

import Foundation

struct Category: Identifiable, Hashable {
    let id: UUID = UUID()
    var name: String
    let title: String
}

class CategoryStore {
    var categories: [Category] = []
    
    init() {
        categories = [
            Category(name: "board", title: "대시보드"),
            Category(name: "qna", title: "Q&A 관리"),
        ]
    }
}
