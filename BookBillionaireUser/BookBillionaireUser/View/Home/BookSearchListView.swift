//
//  SearchListView.swift
//  BookBillionaireUser
//
//  Created by 홍승표 on 4/11/24.
//

import SwiftUI
import BookBillionaireCore

struct BookSearchListView: View {
    @Binding var searchBook: String
    @Binding var filteredBooks: [Book]
    let users: [User] = []
    let bookService = BookService.shared
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("검색된 책 목록")
                    .font(.title3)
                    .foregroundStyle(.accent)
                Spacer()
            }
            
            if filteredBooks.isEmpty {
                Text("검색한 결과가 없습니다")
                
            } else {
                LazyVStack(alignment: .leading, spacing: 10) {
                    ForEach(filteredBooks) { book in
                        NavigationLink {
                            BookDetailView(book: book, user: user(for: book))
                        } label: {
                            BookListRowView(book: book)
                        }

//                        NavigationLink(value: book) {
//                            BookListRowView(book: book)
//                        }
                    }
                    .foregroundStyle(.primary)
//                    .navigationDestination(for: Book.self) { book in
//                        BookDetailView(book: book, user: user(for: book))
//                    }
                }
            }
        }
    }

    
    // BookDetailView에 전달할 User를 가져오는 메서드
    // User 반환
    func user(for book: Book) -> User {
        // book.ownerID == user.id 일치 확인 후 값 return
        if let user = users.first(where: { $0.id == book.ownerID }) {
            return user
        }
        // 일치값 없으면 일단 그냥 샘플 불러오게 처리
        return User(id: "정보 없음", nickName: "정보 없음", address: "정보 없음")
    }
    
}

#Preview {
    BookSearchListView(searchBook: .constant("원도"), filteredBooks: .constant([]))
}

