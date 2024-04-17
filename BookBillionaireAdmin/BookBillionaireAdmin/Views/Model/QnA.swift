//
//  QnA.swift
//  BookBillionaireAdmin
//
//  Created by YUJIN JEON on 4/16/24.
//

import Foundation

struct QnA{
    var id: UUID
    var title: String
    var content: String
    var image: String?
}

class QnAService: ObservableObject {
    public var lists: [QnA] = []
    

   
}
