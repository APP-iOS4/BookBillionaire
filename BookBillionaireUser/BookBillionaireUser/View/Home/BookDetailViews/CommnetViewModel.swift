//
//  CommnetViewModel.swift
//  BookBillionaireUser
//
//  Created by 홍승표 on 4/16/24.
//

import Foundation
import BookBillionaireCore

class CommnetViewModel: ObservableObject {
    @Published var comments: [Commnets] = [
    ]
    
    func delete(_ comment: Commnets) {
        comments.removeAll { $0.id == comment.id}
    }
    // 유저의 댓글 생성
    func add(user: User, commentText: String, star: Int, date: Date) {
        let newComment = Commnets(user: user, comment: commentText, star: star, date: date)
        comments.append(newComment)
    }
    
    // 존재 확인 중복막기
    func exists(_ comment: Commnets) -> Bool{
        comments.contains { $0.id == comment.id }
    }
    
    
}
