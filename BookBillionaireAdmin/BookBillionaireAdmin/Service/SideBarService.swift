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
                Topic(name: "책 목록 등록 및 수정", Icon: "books.vertical.fill", topicTitle: .book),
            ]),
            SideBarGroup(category: "유저 관리", topics: [
                Topic(name: "유저 목록확인", Icon: "person.3.fill", topicTitle: .user),
                Topic(name: "신고 유저 관리", Icon: "exclamationmark.triangle.fill", topicTitle: .complain),
                Topic(name: "유저 CS관리", Icon: "ellipsis.message", topicTitle: .chat),
            ]),
            SideBarGroup(category: "게시글 관리", topics: [
                Topic(name: "공지사항관리", Icon: "note.text", topicTitle: .notice),
                Topic(name: "QnA관리", Icon: "doc.plaintext", topicTitle: .qna),
                Topic(name: "이용약관 및 개인정보처리방침", Icon: "person.badge.shield.checkmark", topicTitle: .policy)

                
            ])
        ]
    }
}

