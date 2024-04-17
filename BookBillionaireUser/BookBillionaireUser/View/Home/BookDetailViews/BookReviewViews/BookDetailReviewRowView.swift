//
//  BookDetailReviewRowView.swift
//  BookBillionaireUser
//
//  Created by 홍승표 on 4/16/24.
//

import SwiftUI
import BookBillionaireCore

struct BookDetailReviewRowView: View {
    let user: User
    let comment: Comments
    
    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            HStack(alignment: .center) {
                Image(user.image ?? "")
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 50, height: 50)
                Text(user.nickName)
                    .font(.headline)
                Spacer()
                Text("\(comment.relativeTime)")
            }
            
            HStack(alignment: .top) {
                ForEach(1...5, id: \.self) { index in // star의 값에 따라 별의 개수를 표시
                    if index <= comment.star {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                    } else {
                        Image(systemName: "star")
                            .foregroundStyle(.gray)
                    }
                }
            }
                .padding(.vertical, 8)
            Text(comment.comment)
        }
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
        .background(Color.gray.opacity(0.1))
    }
}

#Preview {
    BookDetailReviewRowView(user: User(id: "", nickName: "", address: ""), comment: Comments.example)
}
