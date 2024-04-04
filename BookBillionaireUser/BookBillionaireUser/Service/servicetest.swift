//
//  servicetest.swift
//  BookBillionaireUser
//
//  Created by YUJIN JEON on 4/3/24.
//

import SwiftUI
import BookBillionaireCore

struct servicetest: View {
    let bookService = BookService.shared
    let book = BookStore().books.first!
    
    var body: some View {
        Button("저장") {
            Task {
                await bookService.deleteBook(book)
            }
        }
    }
}

#Preview {
    servicetest()
}
