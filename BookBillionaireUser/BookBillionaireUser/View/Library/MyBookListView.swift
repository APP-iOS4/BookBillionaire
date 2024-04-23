//
//  MyBookListView.swift
//  BookBillionaireUser
//
//  Created by Woo Sung jong on 4/3/24.
//

import SwiftUI
import BookBillionaireCore

struct MyBookListView: View {
    @EnvironmentObject var bookService: BookService
    @EnvironmentObject var userService: UserService
    @State private var myBooks: [Book] = []
    @State private var isShowingAlert: Bool = false
    @State private var showToast = false
    @State private var alertBookID: String = ""
    
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
            // 보유도서가 없을 때
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
                // 보유도서가 있을 때
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach(myBooks.indices, id: \.self) { index in
                            HStack(alignment: .top) {
                                NavigationLink {
                                    RentalCreateView(book: $myBooks[index])
                                        .toolbar(.hidden, for: .tabBar)
                                } label: {
                                    BookItem(book: myBooks[index])
                                }
                                Spacer()
                                // 메뉴 버튼
                                Menu {
                                    NavigationLink {
                                        BookCreateView(viewType: .edit(book: myBooks[index]))
                                    } label: {
                                        Label("편집", systemImage: "pencil")
                                    }
                                    Button(role: .destructive) {
                                        alertBookID = myBooks[index].id
                                        isShowingAlert.toggle()
                                    } label: {
                                        Label("삭제", systemImage: "trash.circle.fill")
                                    }
                                } label: {
                                    Image(systemName: "ellipsis")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 17, height: 17)
                                        .foregroundStyle(.gray.opacity(0.4))
                                        .rotationEffect(.degrees(90))
                                }
                                // 알럿
                                .alert("경고", isPresented: $isShowingAlert) {
                                    Button(role: .cancel) {
                                        
                                    } label: {
                                        Text("취소")
                                    }
                                    // 1. 삭제시 rentalService에 remove 메서드 구현해서 추가 해야함.
                                    Button(role: .destructive) {
                                        deleteMyBook(alertBookID)
                                        showToastMessage()
                                        isShowingAlert.toggle()
                                    } label: {
                                        Text("삭제")
                                    }
                                } message: {
                                    Text("""
                                        삭제시 복구가 불가능 합니다.
                                        """)
                                }
                            }
                        }
                    }
                    .padding()
                    SpaceBox()
                }
            }
        }
        // 토스트 메시지
        .toast(isShowing: $showToast, text: Text("도서가 삭제되었습니다."))
        .onAppear{
            loadMybook()
        }
        
        .onReceive(bookService.$books) { _ in
            loadMybook()
        }
    }
    
    // 내 책 불러오기 함수
    private func loadMybook() {
        Task {
            myBooks = bookService.filterByOwenerID(userService.currentUser.id)
        }
    }
    
    // 내 책 삭제 함수
    private func deleteMyBook(_ bookID: String) {
        if let index = myBooks.firstIndex(where: { $0.id == bookID }) {
            let book = myBooks[index]
            Task {
                await bookService.deleteBook(book)
                myBooks.remove(at: index)
            }
        }
    }
    
    // 토스트 함수
    func showToastMessage() {
        withAnimation {
            self.showToast = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                self.showToast = false
            }
        }
    }
}

#Preview {
    NavigationStack {
        MyBookListView()
            .environmentObject(BookService())
            .environmentObject(UserService())
    }
}
