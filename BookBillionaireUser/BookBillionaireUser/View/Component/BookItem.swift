//
//  BookItem.swift
//  BookBillionaireUser
//
//  Created by Woo Sung jong on 4/9/24.
//

import SwiftUI
import BookBillionaireCore

struct BookItem: View {
    var book: Book
    
    var body: some View {
        NavigationLink(value: book) {
            HStack(alignment: .top) {
                if book.thumbnail == "" ||  book.thumbnail.isEmpty {
                    Image("default")
                        .resizable()
                        .frame(width: 100, height: 120)
                        .background(Color.gray)
                } else {
                    AsyncImage(url: URL(string: book.thumbnail)) { image in
                        image.resizable()
                            .frame(width: 100, height: 120)
                            .background(Color.gray)
                    } placeholder: {
                        ProgressView()
                    }
                }
                VStack(alignment: .leading) {
                    Text(book.title)
                    Text(book.authors.joined(separator: ", "))
                    Spacer()
                }
                .foregroundStyle(Color.black)
                Spacer()
            }
        }
    }
}

