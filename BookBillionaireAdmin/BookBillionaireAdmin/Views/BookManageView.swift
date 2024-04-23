//
//  BookManageView.swift
//  BookBillionaireAdmin
//
//  Created by YUJIN JEON on 4/23/24.
//

import SwiftUI
import BookBillionaireCore

struct BookManageView: View {
    @EnvironmentObject private var bookService: BookService
    @State var books : [Book] = []
    @State var multiSelectedBooks: [Book] = []
    var topic: Topic
    var body: some View {
        Grid {
            GridRow {
                Text("책이름")
                
                Image(systemName: "globe")
            }
            Divider()
            GridRow {
                Image(systemName: "hand.wave")
                Text("World")
            }
        }
        .navigationTitle(topic.name)
        .task{
                bookService.fetchBooks()
        }
        .onReceive(bookService.$books, perform: { _ in books = bookService.books })

    }
}

#Preview {
    NavigationStack {
        BookManageView(topic: Topic(name: "책 목록확인", Icon: "books.vertical.fill", topicTitle: .book))
            .environmentObject(BookService())
    }
}
