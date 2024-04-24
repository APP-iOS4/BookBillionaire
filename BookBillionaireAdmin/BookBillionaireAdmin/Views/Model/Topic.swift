//
//  Topic.swift
//  BookBillionaireAdmin
//
//  Created by YUJIN JEON on 4/22/24.
//

import Foundation

public struct Topic: Identifiable {
    public var id: UUID = UUID()
    public var name: String
    public var Icon: String
    public var topicTitle: TopicTitle
}

public enum TopicTitle {
    case user
    case book
    case bookManage
    case userManage
    case blackList
}


