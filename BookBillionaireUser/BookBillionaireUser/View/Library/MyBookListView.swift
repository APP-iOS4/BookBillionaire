//
//  MyBookListView.swift
//  BookBillionaireUser
//
//  Created by Woo Sung jong on 4/3/24.
//

import SwiftUI
import BookBillionaireCore

struct MyBookListView: View {
    let bookService: BookService = BookService.shared
    @State var myBooks: [Book] = []
    
    var body: some View {
        VStack {
            HStack {
                Text("보유도서 목록")
                    .font(.title3)
                    .foregroundStyle(Color.accentColor)
                    .fontWeight(.medium)
                Spacer()
            }
            .padding()
            if myBooks.isEmpty {
                VStack(spacing: 10) {
                    Spacer()
                    Circle()
                        .stroke(lineWidth: 3)
                        .overlay {
                            Image(systemName: "book")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(20)
                        }
                        .frame(width: 70, height: 70)
                    
                    Text("보유중인 도서가 없습니다.")
                    Text("책을 추가하면 여기에 표시됩니다.")
                    Spacer()
                }
                .font(.title3)
                .fontWeight(.medium)
                .foregroundStyle(.gray)
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach(myBooks, id: \.self) { book in
                            BookItem(book: book)
                        }
                    }
                    .padding()
                    // DetailView 미구현, 추후 변경
                    .navigationDestination(for: Book.self) { book in
                        Text("안녕 \(book.title) 디테일 뷰")
                    }
                    SpaceBox()
                }
            }
        }
        .onAppear{
            loadMybook()
        }
    }
    
    private func loadMybook() {
        Task {
            if let user = AuthViewModel().currentUser {
                myBooks = await bookService.loadBookByID(user.uid)
            }
        }
    }
    
    private func removeList(at offsets: IndexSet) {
        myBooks.remove(atOffsets: offsets)
    }
}

#Preview {
    NavigationStack {
        MyBookListView()
    }
}
