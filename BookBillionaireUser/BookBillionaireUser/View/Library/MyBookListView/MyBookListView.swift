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
    @EnvironmentObject var rentalService: RentalService
    var myBooks: [Book] {
        return  bookService.filterByOwenerID(userService.currentUser.id)
    }
    @State private var isShowingAlert: Bool = false
    @State private var showToast = false
    @State private var alertBookID: String = ""
    @State private var isShowingEdit: Bool = false
    @State private var selectedBook: Book?
    
    var body: some View {
        VStack {
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
                        ForEach(myBooks) { book in
                            HStack(alignment: .top) {
                                NavigationLink(value: book) {
                                    BookItem(book: book)
                                }
                                Spacer()
                                // 메뉴 버튼
                                Menu {
                                    Button {
                                        selectedBook = book
                                        isShowingEdit = true
                                    } label: {
                                        Label("편집", systemImage: "pencil")
                                    }
                                    Button(role: .destructive) {
                                        alertBookID = book.id
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
                        .navigationDestination(for: Book.self) { book in
                            RentalCreateView(book: book)
                                .toolbar(.hidden, for: .tabBar)
                        }
                    }
                    .padding()
                    SpaceBox()
                }
                .refreshable {
                    bookService.fetchBooks()
                }
            }
        }
        .fullScreenCover(item: $selectedBook) { bookToEdit in
            NavigationStack {
                BookCreateView(viewType: .edit(book: bookToEdit), isShowing: $isShowingEdit)
            }
        }
        // 토스트 메시지
        .toast(isShowing: $showToast, text: Text("도서가 삭제되었습니다."))
        .onAppear {
            bookService.fetchBooks()
        }
    }
    // 내 책 삭제 함수
    private func deleteMyBook(_ bookID: String) {
        if let book = myBooks.first(where: { $0.id == bookID}) {
            Task {
                if !book.rental.isEmpty {
                    // 렌탈 삭제
                    await rentalService.deleteRentalFromBook(book)
                }
                // 사용자의 myBooks 배열에서 책 ID 제거
                await userService.removeBookFromUser(userID: userService.currentUser.id, bookID: book.id)
                // 책 삭제
                await bookService.deleteBook(book)
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
            .environmentObject(RentalService())
    }
}
