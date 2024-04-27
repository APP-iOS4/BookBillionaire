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
    @State private var loadedImage: UIImage?
    @State private var isShowingAlert: Bool = false
    @State private var selectedBooks: [Book] = []
    @State var isShowingSearch: Bool = false
    @State private var searchText: String = ""
    
    let imageCache = ImageCacheService.shared
    var topic: Topic
    var body: some View {
        VStack{
            HStack{
                Button("등록하기") {
                    isShowingSearch = true
                }
                Button("삭제하기") {
                    isShowingAlert = true
                }
                .frame(width: 200)
                .padding(.trailing, 25)
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
//            .fullScreenCover(isPresented: $isShowingSearch) {
//                APISearchView(searchBook: $searchText, isShowing: $isShowingSearch)
//                    .toolbar(.hidden, for: .tabBar)
//            }
            .navigationTitle(topic.name)
        }
        
    }
    func deleteBooks(_ book: Book) {
        Task {
            await bookService.deleteBook(book)
        }
    }
}

//#Preview {
//    NavigationStack {
//        BookManageView(topic: Topic(name: "책 목록확인", Icon: "books.vertical.fill", topicTitle: .book), isShowingSearch: .constant(true))
//            .environmentObject(BookService())
//    }
//}
