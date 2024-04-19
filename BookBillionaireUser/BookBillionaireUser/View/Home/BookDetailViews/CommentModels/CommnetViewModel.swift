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
        Comments.example2
    ]
    
    // 삭제 함수 ... currentUser? 로그인 한 사용자에게만 댓글 삭제 기능 나오게
    func delete(_ comment: Comments) {
        comments.removeAll { $0.id == comment.id}
    }
    // 유저의 댓글 생성
    func add(user: User, commentText: String, star: Int, date: Date) {
        let newComment = Comments(user: user, comment: commentText, star: star, date: date)
        comments.append(newComment)
    }
    
    // 수정해야 할 때 같은 id값인지 비교하고
    // 수정해야 하는 뷰로 넘어갈때 확인
    func exists(_ comment: Comments) -> Bool{
        comments.contains { $0.id == comment.id }
    }
}
