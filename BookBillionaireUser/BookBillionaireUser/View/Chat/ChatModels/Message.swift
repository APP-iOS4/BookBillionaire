//
//  Message.swift
//  BookBillionaireUser
//
//  Created by 최준영 on 4/7/24.
//

import Foundation

struct Message: Codable {
    
    var id: String?
    var text: String = ""          // 메세지 텍스트
    var username: String = ""      // 해당 메세지를 보낸 유저 닉네임
    var roomId: String = ""        // 방의 Id
    var timestamp: Date            // 메세지를 보낸 시간


    init(vs: MessageViewState) {
        text = vs.message
        username = vs.username
        roomId = vs.roomId
        timestamp = vs.timestamp
    }
}


extension Date {
    func timeAgoFormat(numericDates: Bool = false) -> String {
        let calendar = Calendar.current
        let date = self
        let now = Date()
        let earliest = (now as NSDate).earlierDate(date)
        let latest = (earliest == now) ? date : now
        let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
        
        if components.year! >= 2 {
            return "\(components.year!)년 전"
        } else if components.year! >= 1 {
            if numericDates {
                return "1년 전"
            } else {
                return "지난 해"
            }
        } else if components.month! >= 2 {
            return "\(components.month!)달 전"
        } else if components.month! >= 1 {
            if numericDates {
                return "1달 전"
            } else {
                return "지난 달"
            }
        } else if components.weekOfYear! >= 2 {
            return "\(components.weekOfYear!)주 전"
        } else if components.weekOfYear! >= 1 {
            if numericDates {
                return "1주 전"
            } else {
                return "지난 주"
            }
        } else if components.day! >= 2 {
            return "\(components.day!)일 전"
        } else if components.day! >= 1 {
            if numericDates {
                return "1일 전"
            } else {
                return "어제"
            }
        } else if components.hour! >= 2 {
            return "\(components.hour!)시간 전"
        } else if components.hour! >= 1 {
            if numericDates {
                return "1시간 전"
            } else {
                return "시간 전"
            }
        } else if components.minute! >= 2 {
            return "\(components.minute!)분 전"
        } else if components.minute! >= 1 {
            if numericDates {
                return "1분 전"
            } else {
                return "분 전"
            }
        } else {
            return "지금"
        }
    }
}
