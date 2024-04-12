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
    @State private var isShowingAlert: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Text("보유도서 목록")
                    .font(.title3)
                    .foregroundStyle(Color.accentColor)
                    .fontWeight(.medium)
                Spacer()
            }
            .padding()
            if myBooks.isEmpty {
                VStack(spacing: 10) {
                    Spacer()
                    Circle()
                        .stroke(lineWidth: 3)
                        .overlay {
                            Image(systemName: "book")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(20)
                        }
                        .frame(width: 70, height: 70)
                    
                    Text("보유중인 도서가 없습니다.")
                    Text("책을 추가하면 여기에 표시됩니다.")
                    Spacer()
                }
                .font(.title3)
                .fontWeight(.medium)
                .foregroundStyle(.gray)
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach(myBooks) { book in
                            HStack(alignment: .top) {
                                BookItem(book: book)
                                Spacer()
                                // 메뉴 버튼
                                Menu {
                                    Button {
                                        
                                    } label: {
                                        Label("편집", systemImage: "pencil")
                                    }
                                    Button(role: .destructive) {
                                        isShowingAlert.toggle()
                                    } label: {
                                        Label("삭제", systemImage: "trash.circle.fill")
                                    }
                                } label: {
                                    Image(systemName: "ellipsis")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 17)
                                        .foregroundStyle(.gray.opacity(0.4))
                                        .rotationEffect(.degrees(90))
                                }
                                .alert("", isPresented: $isShowingAlert) {
                                    Button(role: .cancel) {
                                        
                                    } label: {
                                        Text("취소")
                                    }
                                    // 1. 삭제시 rentalService에 remove 메서드 구현해서 추가 해야함.
                                    Button(role: .destructive) {
                                        deleteMyBook(book)
                                    } label: {
                                        Text("삭제")
                                    }
                                } message: {
                                    Text("""
                                        삭제시 복구가 불가능 합니다.
                                        삭제하시겠습니까?
                                        """)
                                }
                                .padding()
                            }
                        }
                    }
                    .padding()
                    // DetailView 미구현, 추후 변경
                    .navigationDestination(for: Book.self) { book in
                        Text("안녕 \(book.title) 디테일 뷰")
                    }
                    SpaceBox()
                }
            }
        }
        .onAppear{
            loadMybook()
        }
    }
    
    private func loadMybook() {
        Task {
            if let user = AuthViewModel().currentUser {
                myBooks = await bookService.loadBookByID(user.uid)
            }
        }
    }
    
    private func deleteMyBook(_ book: Book) {
        Task {
            await bookService.deleteBook(book)
            if let index = myBooks.firstIndex(where: { $0.id == book.id }) {
                myBooks.remove(at: index)
            }
        }
    }
}

#Preview {
    NavigationStack {
        MyBookListView()
    }
}
