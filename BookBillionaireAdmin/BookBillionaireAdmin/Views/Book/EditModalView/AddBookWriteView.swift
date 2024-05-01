//
//  AddBookWriteView.swift
//  BookBillionaireAdmin
//
//  Created by YUJIN JEON on 4/30/24.
//

import SwiftUI
import BookBillionaireCore

struct AddBookWriteView: View {
    @State private var books: [Book] = []
    @State private var infoText: String = "입력하실 책을 입력하고 등록해주세요."
    @EnvironmentObject var bookService: BookService
    @Environment (\.dismiss) var dismiss
    @State private var bookTitle: String = ""
    @State private var isbn: String = ""
    @State private var publisher: String = ""
    @State private var authors: [String] = []
    @State private var translators: [String] = []
    @State private var contents: String = ""
    @State private var thumbnail: String = ""
    private var rental: String = ""
    private var rentalState: RentalStateType = .rentalAvailable
    
    var body: some View {
        VStack{
            Text("직접 입력으로 책 등록하기")
                .padding()
                .font(.title2)
            Text(infoText).font(.subheadline)
            HStack{
                Form {
                    VStack{
                        HStack{
                            Rectangle().frame(width: 120, height: 140)
                        }
                        TextField("isbn",text: $bookTitle)
                        TextField("출판사",text: $bookTitle)
                        TextField("authors",text: $bookTitle)
                        TextField("책 이름",text: $bookTitle)
                        TextField("책 이름",text: $bookTitle)
                        TextField("책 이름",text: $bookTitle)
                        TextField("책 이름",text: $bookTitle)
                        TextField("책 이름",text: $bookTitle)
                        TextField("책 이름",text: $bookTitle)
                    }
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
    AddBookWriteView()
}
