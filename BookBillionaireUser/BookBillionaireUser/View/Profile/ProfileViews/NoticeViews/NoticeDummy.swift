//
//  NoticeDummy.swift
//  BookBillionaireUser
//
//  Created by 홍승표 on 4/26/24.
//

import Foundation

struct NoticeDummy: Identifiable {
    var id = UUID()
    var title: String
    var content: String
    var date = Date()
    
    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 hh:mm"
        return dateFormatter.string(from: date)
    }
}

let dummyNotice = [
    NoticeDummy(title: "공지사항1", content: "안녕 난 공지1"),
    NoticeDummy(title: "공지사항2", content: "안녕 난 공지2"),
    NoticeDummy(title: "공지사항3", content: "안녕 난 공지3"),
    NoticeDummy(title: "공지사항4", content: "안녕 난 공지4")
]
