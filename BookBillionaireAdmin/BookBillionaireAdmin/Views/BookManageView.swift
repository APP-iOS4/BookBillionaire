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
        .task{
                bookService.fetchBooks()
        }
        .onReceive(bookService.$books, perform: { _ in books = bookService.books })

    }
}

#Preview {
    BookManageView()
        .environmentObject(BookService())
}
