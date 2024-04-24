//
//  BookListView.swift
//  BookBillionaireAdmin
//
//  Created by YUJIN JEON on 4/23/24.
//

import SwiftUI
import BookBillionaireCore

struct BookListView: View {
    @EnvironmentObject var bookService: BookService
    @State var selectedBooks: [Book] = []
    @State var isPresentedEditCategory: Bool = false
    @State var bookCategory: BookCategory = .best
    var topic: Topic
    var gridLayout: [GridItem] = Array(repeating: .init(.flexible()), count: 5)
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text("해당 화면에서 책의 이미지와 해당 정보에 대한 수정 가능")
                    .padding(.leading)
                Spacer()
//                Button("카테고리 변경") {
//                    isPresentedEditCategory = true
//                }
//                .frame(width: 200)
//                .padding(.trailing)
//                .buttonStyle(AccentButtonStyle())
                Button("삭제하기") {
                    for book in selectedBooks {
                        deleteBooks(book)
                    }
                    selectedBooks = []
                }
                .frame(width: 200)
                .padding(.trailing)
                .buttonStyle(AccentButtonStyle())
            }
            ScrollView {
                LazyVGrid(columns: gridLayout, spacing: 10) {
                    ForEach(bookService.books, id: \.self) { book in
                        GridCell(book: book, selectedBooks: $selectedBooks)
                            .padding(10)
                    }
                    .padding(5)
                }
                .padding(30)
            }
            .navigationTitle(topic.name)
        }
        .sheet(isPresented: $isPresentedEditCategory, content: {
            CategroyEditView(bookCategory: $bookCategory, books: $selectedBooks)
        })
    }
    func deleteBooks(_ book: Book) {
        Task {
            await bookService.deleteBook(book)
        }
    }
    func updateCategory(_ book: Book, bookCategory: BookCategory) {
        Task {
            await bookService.updateBookCategory(book.id,bookCategory: bookCategory)
        }
    }
    
}

#Preview {
    NavigationStack{
        BookListView(topic:  Topic(name: "책 목록확인", Icon: "books.vertical.fill", topicTitle: .book))
            .environmentObject(BookService())
            .onAppear{
                BookService().fetchBooks()
            }
    }
}
