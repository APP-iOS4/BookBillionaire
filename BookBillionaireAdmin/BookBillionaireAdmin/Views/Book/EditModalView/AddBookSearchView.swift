//
//  AddBookSearchView.swift
//  BookBillionaireAdmin
//
//  Created by YUJIN JEON on 4/30/24.
//

import SwiftUI
import BookBillionaireCore

struct AddBookSearchView: View {
    @State private var books: [Book] = []
    @State private var infoText: String = "입력하실 책을 검색하고 등록해주세요."
    @EnvironmentObject var bookService: BookService
    @Environment (\.dismiss) var dismiss
    
    var body: some View {
        VStack{
            Text("검색으로 책 등록하기")
                .padding()
                .font(.title2)
            Text(infoText).font(.subheadline)
            HStack{
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(books, id: \.self) { book in
                            BookGridCellInfo(book: book)
                        }
                    }
                    .background(Color.red).padding(30)
                }
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(books, id: \.self) { book in
                            BookGridCellInfo(book: book)
                        }
                    }.padding(30)
                }
            }
            Button("책 등록하기") {
                for book in books {
                    if !bookService.registerBook(book) {
                        infoText = "책 등록에 실패했습니다."
                        break
                    }
                }
                dismiss()
            }.buttonStyle(AccentButtonStyle())
                .padding(30)
        }
    }
    func updateCategory(_ book: Book, bookCategory: BookCategory) {
        Task {
            await bookService.updateBookCategory(book.id, bookCategory: bookCategory)
        }
    }
}

#Preview {
    AddBookSearchView()
}
