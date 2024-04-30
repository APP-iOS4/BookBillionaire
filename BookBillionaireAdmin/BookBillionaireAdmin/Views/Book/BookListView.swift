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
    @State private var selectedBooks: [Book] = []
    @State private var isShowingAlert: Bool = false
    @State private var isPresentedEditCategory: Bool = false
    @State private var isAddBookForSearch: Bool = false
    @State private var isAddBookForWrite: Bool = false

    var topic: Topic
    var gridLayout: [GridItem] = Array(repeating: .init(.flexible()), count: 4)
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Spacer()
//                Button("책 등록하기(검색)") {
//                    isAddBookForSearch = true
//                }
//                .fixedSize()
//                .buttonStyle(AccentButtonStyle())
//                Button("책 등록하기(입력)") {
//                    isAddBookForWrite = true
//                }
//                .fixedSize()
//                .buttonStyle(AccentButtonStyle())
                Button("카테고리 변경") {
                    isPresentedEditCategory = true
                }
                .fixedSize()
                .buttonStyle(AccentButtonStyle())
                Button("삭제하기") {
                    isShowingAlert = true
                }
                .fixedSize()
                .buttonStyle(AccentButtonStyle())
                .alert("경고", isPresented: $isShowingAlert) {
                    Button(role: .cancel) {
                        isShowingAlert = false
                    } label: {
                        Text("취소")
                    }
                    Button(role: .destructive) {
                        for book in selectedBooks {
                            deleteBooks(book)
                        }
                        selectedBooks = []
                        isShowingAlert.toggle()
                    } label: {
                        Text("삭제")
                    }
                } message: {
                    Text("""
                    삭제시 복구가 불가능 합니다.
                    """)
                }
            }
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
        .sheet(isPresented: $isPresentedEditCategory, content: {
            CategroyEditView(books: $selectedBooks)
        })
        .sheet(isPresented: $isAddBookForSearch, content: {
            AddBookSearchView()
        })
        .sheet(isPresented: $isAddBookForWrite, content: {
            AddBookWriteView()
        })
    }
    func deleteBooks(_ book: Book) {
        Task {
            await bookService.deleteBook(book)
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
