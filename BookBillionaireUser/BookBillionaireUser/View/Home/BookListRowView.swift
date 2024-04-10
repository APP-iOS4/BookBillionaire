//
//  BookListView.swift
//  BookBillionaireUser
//
//  Created by 홍승표 on 4/4/24.
//

import SwiftUI
import BookBillionaireCore

struct BookListRowView: View {
    var book: Book
    
    var body: some View {
        HStack {
            HStack(alignment:.top, spacing: 15) {
                AsyncImage(url: URL(string: book.thumbnail)){ image in
                    image.resizable()
                        .frame(width: 100, height: 140)
                } placeholder: {
                    ProgressView()
                }

                VStack(alignment:.leading) {
                    Text(book.title)
                        .font(.subheadline)
                    Text("\(book.title) \(book.authors.joined(separator: ""))")
                        .font(.caption)
                        .padding(.bottom, 10)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 30)
            }
        }
    }
}
