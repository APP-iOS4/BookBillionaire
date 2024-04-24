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
    @EnvironmentObject var userService: UserService
    
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
                            BookDetailView(book: book, user: userService.loadUserByID(book.ownerID))
                        } label: {
                            BookItem(book: book)
                        }
                        
                    }
                    .foregroundStyle(.primary)
                }
            }
        }
    }
    
}

#Preview {
    BookSearchListView(searchBook: .constant("재채기 멋있게 하는 방법"), filteredBooks: .constant([Book(ownerID: "",ownerNickname: "", title: "재채기 멋있게 하는 방법", contents: "", authors: [""], rentalState: .rentalAvailable)]))
        .environmentObject(UserService())
}

