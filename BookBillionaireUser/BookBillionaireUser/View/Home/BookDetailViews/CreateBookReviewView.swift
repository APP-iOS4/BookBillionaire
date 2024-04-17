//
//  CreateBookReviewView.swift
//  BookBillionaireUser
//
//  Created by 홍승표 on 4/16/24.
//

import SwiftUI
import BookBillionaireCore

struct CreateBookReviewView: View {
    let user: User
    @StateObject var commentViewModel = CommnetViewModel()
    @State private var textComment: String = ""
    @State private var rating: Int = 0
    @State private var photoItemShowing = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("별점으로 점수를 매겨보세요.")
                .font(.caption)
                .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
            
            HStack(alignment: .center, spacing: 5) {
                ForEach(1...5, id: \.self) { index in
                    Button {
                        self.rating = index
                    } label: {
                        Image(systemName: index <= rating ? "star.fill" : "star")
                            .foregroundStyle(index <= rating ? .yellow : .gray)
                    }
                }
            }
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
            
            HStack {
                Button {
                    photoItemShowing.toggle()
                } label: {
                    photoItemShowing ? Image(systemName: "xmark") : Image(systemName: "plus")
                    //하아 포토피커 해야됩니까?
                }
                .padding(.horizontal,10)
                
                TextField("코멘트를 입력해주세요.", text: $textComment)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .disableAutocorrection(true)
                
                Button {
                    commentViewModel.add(user: user, commentText: textComment, star: rating, date: Date())
                    textComment = ""
                    rating = 0
                    
                } label: {
                    ZStack {
                        RoundedRectangle(cornerSize: CGSize(width: 5, height: 5))
                            .foregroundStyle(Color.accentColor)
                        Image(systemName: "paperplane")
                            .foregroundStyle(.white)
                    }
                    .frame(width: 40, height: 40)
                }
            }
            .padding(.bottom, 8)
            .padding(.top, 0)
            .padding(.horizontal)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

#Preview {
    CreateBookReviewView(user: User(id: "", nickName: "유저", address: ""))
}
