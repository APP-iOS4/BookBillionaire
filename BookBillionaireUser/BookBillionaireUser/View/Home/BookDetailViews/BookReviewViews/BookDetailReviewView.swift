//
//  BookAnotherOwnerView.swift
//  BookBillionaireUser
//
//  Created by 홍승표 on 4/16/24.
//

import SwiftUI
import BookBillionaireCore

struct BookDetailReviewView: View {
    let comments: [Comments]
    let user: User
    @State private var sortByDateAscending = true
    
    // 코멘트 날짜 정렬
    // 단일 객체 x, 배열로!
    var sortedComments: [Comments] {
        if sortByDateAscending {
            return comments.sorted(by: { $0.date < $1.date })
        } else {
            return comments.sorted(by: { $0.date > $1.date })
        }
    }
    
    var body: some View {
        // 책 목록
        VStack{
            HStack(alignment: .center) {
                Text("📖 다른 이용자들 후기")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.bottom, 5)
                Spacer()
                HStack(alignment: .center) {
                    Text(sortByDateAscending ? "최신순" : "오래된순")
                        .font(.caption)
                    Image(systemName: "arrow.up.arrow.down")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 12)
                }
                .padding(10)
                .onTapGesture {
                    sortByDateAscending.toggle()
                }
                .foregroundStyle(Color.primary)
            }
            
            VStack {
                // 책 관련 리뷰들 순차로 나열 (생성된 리뷰들만 가능) 샘플 ㄴㄴ
                ForEach(sortedComments, id: \.id) { sortedComment in
                    BookDetailReviewRowView(user: user, comment: sortedComment)
                }
            }
        }
    }
}

#Preview {
    BookDetailReviewView(comments: [Comments.example, Comments.example2], user: User(id: "", nickName: "", address: ""))
}



