//
//  CommnetViewModel.swift
//  BookBillionaireUser
//
//  Created by 홍승표 on 4/16/24.
//

import Foundation
import BookBillionaireCore

class CommnetViewModel: ObservableObject {
    @Published var comments: [Comments] = [
        Comments.example,
        Comments.example2,
        Comments.example3,
    ]
    
    func delete(_ comment: Comments) {
        comments.removeAll { $0.id == comment.id}
    }
    // 유저의 댓글 생성
    func add(user: User, commentText: String, star: Int, date: Date) {
        let newComment = Comments(user: user, comment: commentText, star: star, date: date)
        comments.append(newComment)
    }
    
    // 존재 확인 중복막기
    func exists(_ comment: Comments) -> Bool{
        comments.contains { $0.id == comment.id }
    }
}
