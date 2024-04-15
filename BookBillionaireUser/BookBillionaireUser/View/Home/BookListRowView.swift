//
//  BookListView.swift
//  BookBillionaireUser
//
//  Created by 홍승표 on 4/4/24.
//

import SwiftUI
import BookBillionaireCore

struct BookListRowView: View {
    let book: Book
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment:.top) {
                AsyncImage(url: URL(string: book.thumbnail)){ image in
                    image.resizable()
                        .frame(width: 100, height: 140)
                } placeholder: {
                    ProgressView()
                }
                
                VStack(alignment: .leading) {
                    Text(book.title)
                        .font(.subheadline)
                        .padding(.bottom, 5)
                    if book.authors.isEmpty {
                        Text("\(book.title)")
                            .font(.caption)
                        Text("\(book.translators?.joined(separator: ", ") ?? "")")
                            .multilineTextAlignment(.leading)
                            .font(.caption)
                            .padding(.bottom, 10)
                    } else {
                        Text("\(book.title)")
                            .font(.caption)
                        Text("\(book.authors.joined(separator: ", "))")
                            .multilineTextAlignment(.leading)
                            .font(.caption)
                            .padding(.bottom, 10)
                    }
                }
                .padding(.leading, 10)
            }
        }
    }
}

#Preview {
    BookListRowView(book: BookService.shared.books[0])
}
