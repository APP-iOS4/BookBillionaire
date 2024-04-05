//
//  MyBookListView.swift
//  BookBillionaireUser
//
//  Created by Woo Sung jong on 4/3/24.
//

import SwiftUI
import BookBillionaireCore

struct MyBookListView: View {
    let bookService: BookService = BookService.shared
    @State var myBooks: [Book] = []
    
    var body: some View {
        VStack {
            HStack {
                Text("보유도서 목록")
                    .font(.title3)
                    .foregroundStyle(Color.accentColor)
                    .fontWeight(.medium)
                Spacer()
            }
            LazyVStack(alignment: .leading, spacing: 10) {
                // bookStore 미구현, 추후 변경
                ForEach(myBooks, id: \.self) { book in
                    // ListRowView 미구현, 추후 변경
                    NavigationLink(value: book) {
                        HStack {
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
                        }
                    }
                }
                .foregroundStyle(Color.black)
            }
        }
        // DetailView 미구현, 추후 변경
        .navigationDestination(for: Int.self) { value in
            Text("안녕 DetailView")
        }
        .padding()
        .onAppear{
            loadMybook()
        }
    }
    private func loadMybook() {
        Task {
            myBooks = await bookService.loadBookByID("Eyhr4YQGsATlRDUcc9rYl9PZYk52")
            
        }
    }
}

#Preview {
    NavigationStack {
        MyBookListView()
    }
}
