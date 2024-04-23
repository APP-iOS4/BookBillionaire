//
//  APISearchListRowView.swift
//  BookBillionaireUser
//
//  Created by YUJIN JEON on 3/26/24.
//

import SwiftUI
import BookBillionaireCore

struct APISearchListRowView: View {
    var book : SearchBook
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: book.thumbnail)){ image in
                image.resizable()
                    .frame(width: 100, height: 140)
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Image("default")
                    .resizable()
                    .frame(width: 100, height: 140)
            }
            .padding(.trailing)
            VStack(alignment:.leading) {
                Text(book.title)
                    .font(.subheadline)
                    .padding(.top)
                Text("\(book.authors.joined()) \(book.translators.joined())")
                    .font(.caption)
                    .padding(.bottom, 10)
                Spacer()
                HStack(alignment: .bottom) {
                    Text(book.publisher)
                        .font(.caption)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 30)
        }
        .padding(.horizontal)
    }
}
