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
    @State var selectedBooks: Bool = false
    @Binding var isShowing: Bool
    
    var body: some View {
                Button {
                    selectedBooks.toggle()
                    isShowing.toggle()
                } label: {
                    HStack {
                    AsyncImage(url: URL(string: book.thumbnail)){ image in
                        image.resizable()
                            .frame(maxWidth: 80, maxHeight: 120)
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ProgressView()
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
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .foregroundStyle(selectedBooks ? Color.green : Color.gray)
                }
            }
            .padding(.horizontal)
    }
}
