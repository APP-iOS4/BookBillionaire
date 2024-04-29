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
    let comment: Reviews
    
    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            HStack(alignment: .center) {
                if let url = URL(string: user.image ?? "") {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 50, height: 50)
                    } placeholder: {
                        Image("default")
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 50, height: 50)
                    }
                } else {
                    Image("default")
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 50, height: 50)
                }
                Text(user.nickName)
                    .font(.headline)
                Spacer()
                VStack(alignment: .trailing) {
                    HStack(alignment: .top, spacing: 2) {
                        ForEach(1...5, id: \.self) { index in // star의 값에 따라 별의 개수를 표시
                            Star(filled: index <= comment.star)
                        }
                    }
                    .padding(.bottom, 5)
                    Text("\(comment.relativeTime)")
                        .font(.caption)
                }
            }
            .padding(.vertical, 8)
            Text(comment.comment)
                .font(.caption)
        }
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
        .background(Color.gray.opacity(0.1))
    }
}

#Preview {
    BookDetailReviewRowView(user: User(nickName: "", address: "", email: ""), comment: Reviews.example)
}
