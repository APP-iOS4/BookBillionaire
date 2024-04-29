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
    var topic: Topic
    var gridLayout: [GridItem] = Array(repeating: .init(.flexible()), count: 5)
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Spacer()
                Button("카테고리 변경") {
                    isPresentedEditCategory = true
                }
                .frame(width: 200)
                .buttonStyle(AccentButtonStyle())
            }.padding()
                ScrollView {
                    LazyVGrid(columns: gridLayout, spacing: 10) {
                        ForEach(bookService.books, id: \.self) { book in
                            BookGridCell(book: book, selectedBooks: $selectedBooks)
                        }
                    }
                }
                .navigationTitle(topic.name)
                .padding(.horizontal, 25)
            }
            .sheet(isPresented: $isPresentedEditCategory, content: {
                CategroyEditView(books: $selectedBooks)
            })
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
