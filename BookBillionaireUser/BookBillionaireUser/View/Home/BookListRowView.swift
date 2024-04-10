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
            HStack(alignment:.top, spacing: 15) {
                AsyncImage(url: URL(string: book.thumbnail)){ image in
                    image.resizable()
                        .frame(width: 100, height: 140)
                } placeholder: {
                    ProgressView()
                }
                
                VStack(alignment: .leading) {
                    Text(book.title)
                        .font(.subheadline)
                    
                    if book.authors.isEmpty {
                        Text("\(book.title) \n \(book.translators?.joined(separator: ", ") ?? "")")
                            .font(.caption)
                            .padding(.bottom, 10)
                    } else {
                        Text("\(book.title) \n \(book.authors.joined(separator: ", "))")
                            .font(.caption)
                            .padding(.bottom, 10)
                    }
                }
                .padding(.bottom, 30)
            }
        }
    }
}
