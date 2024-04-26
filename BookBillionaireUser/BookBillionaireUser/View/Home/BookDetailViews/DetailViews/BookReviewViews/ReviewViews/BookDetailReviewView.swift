//
//  BookAnotherOwnerView.swift
//  BookBillionaireUser
//
//  Created by 홍승표 on 4/16/24.
//

import SwiftUI
import BookBillionaireCore

struct BookDetailReviewView: View {
    let comments: [Reviews]
    let user: User
    @State private var sortByDateAscending = true
    
    // 코멘트 날짜 정렬
    // 단일 객체 x, 배열로!
    var sortedComments: [Reviews] {
        if sortByDateAscending {
            return comments.sorted(by: { $0.date < $1.date })
        } else {
            return comments.sorted(by: { $0.date > $1.date })
        }
    }
    
    var body: some View {
        VStack{
            HStack(alignment: .center) {
              Text("다른 이용자들 후기")
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
                ForEach(sortedComments, id: \.id) { sortedComment in
                    BookDetailReviewRowView(user: user, comment: sortedComment)
                }
            }
        }
    }
}

#Preview {
    BookDetailReviewView(comments: [Reviews.example, Reviews.example2], user: User(nickName: "", address: ""))
}



