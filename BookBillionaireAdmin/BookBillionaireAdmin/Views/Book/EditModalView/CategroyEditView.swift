//
//  CategroyEditView.swift
//  BookBillionaireAdmin
//
//  Created by YUJIN JEON on 4/24/24.
//

import SwiftUI
import BookBillionaireCore

struct CategroyEditView: View {
    @Binding var books: [Book]
    @State var bookCategory: BookCategory = .hometown
    @EnvironmentObject var bookService: BookService
    @Environment (\.dismiss) var dismiss
    
    var body: some View {
        VStack{
            Text("카테고리 변경 목록")
                .padding()
                .font(.title2)
            Text("변경할 카테고리 선택")
                .bold()
            Picker("카테고리", selection: $bookCategory) {
                ForEach(BookCategory.allCases, id: \.self) { category in
                    Text(category.buttonTitle)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(books, id: \.self) { book in
                        BookGridCellInfo(book: book)
                    }
                }.padding(30)
            }
            Button("카테고리 변경") {
                for book in books {
                    updateCategory(book, bookCategory: bookCategory)
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
