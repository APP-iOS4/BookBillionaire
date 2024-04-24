//
//  Commnets.swift
//  BookBillionaireUser
//
//  Created by 홍승표 on 4/16/24.
//

import Foundation
import BookBillionaireCore

struct Reviews: Identifiable {
    var user: User
    var id: UUID = UUID()
    var comment: String = ""
    var star: Int = 0
    var date: Date = Date()
    
    // 코멘트시 옆에 날짜 표기 텍스트
    var relativeTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.day], from: date, to: now)
        var daysDifference = components.day ?? 0
        
        // 음수면 양수로 변환 문자열 반환
        if daysDifference < 0 {
            daysDifference = -daysDifference
        }
        
        if daysDifference == 0 {
            return dateFormatter.string(from: now)
        }
        else if daysDifference == 1 {
            return "어제"
        } else {
            return "\(daysDifference)일 전"
        }
    }
    
    // 샘플
    static var example = Reviews(
        user: User(),
        comment: "마지막 페이지 어디갔나요?",
        star: 3,
        date: Date(timeIntervalSinceNow: 60 * 60 * 24 * 20)
    )
    
    static var example2 = Reviews(
        user: User(),
        comment: "잘 봤습니다",
        star: 4,
        date: Date()
    )
}
