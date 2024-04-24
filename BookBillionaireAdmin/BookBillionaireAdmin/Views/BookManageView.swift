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
    @State var books: [Book] = []
    @State var multiSelectedBooks: [Book] = []
    @State private var loadedImage: UIImage?
    let imageCache = ImageCacheService.shared
    var topic: Topic
    var body: some View {
        VStack{
            List(books) { book in
                HStack{
                    
                }
            }
            
        }
        .navigationTitle(topic.name)
        .task{
            bookService.fetchBooks()
        }
        .task {
            books = bookService.books
        }
    }
}

#Preview {
    NavigationStack {
        BookManageView(topic: Topic(name: "책 목록확인", Icon: "books.vertical.fill", topicTitle: .book))
            .environmentObject(BookService())
    }
}
