//
//  SideBarService.swift
//  BookBillionaireAdmin
//
//  Created by YUJIN JEON on 4/22/24.
//

import Foundation

public class SideBarService: ObservableObject {
    @Published public var sideBarGroup: [SideBarGroup]
    
    public init() {
        sideBarGroup = [
            SideBarGroup(category: "책 관리", topics: [
                Topic(name: "책 목록확인", Icon: "books.vertical.fill", topicTitle: .book),
                Topic(name: "책 등록 및 수정", Icon: "book.and.wrench", topicTitle: .bookManage)
            ]),
            SideBarGroup(category: "유저 관리", topics: [
                Topic(name: "유저 목록확인", Icon: "person.3.fill", topicTitle: .user),
                Topic(name: "유저 등록 및 수정", Icon: "person.2.badge.gearshape", topicTitle: .userManage),
                Topic(name: "신고 유저 관리", Icon: "exclamationmark.triangle.fill", topicTitle: .complain)
            ])
        ]
    }
}

