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
    @State private var myBooks: [Book] = []
    @State private var users: [User] = []
    @State private var isShowingAlert: Bool = false
    @State private var showToast = false
    
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
                                    NavigationLink {
                                        BookCreateView(book: book)
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
                                        showToastMessage()
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
                    // BookDetailView로 연결예정... User가 음슴
                    .navigationDestination(for: Book.self) { book in
                        Text("안녕 \(book.title) 디테일 뷰")
                        BookDetailView(book: book, user: user(for: book))
                    }
                    SpaceBox()
                }
            }
        }
//        .toast(isShowing: $showToast, text: Text("성공했습니다!"))
        .onAppear{
            loadMybook()
        }
    }
    
    private func loadMybook() {
        Task {
            if let user = AuthViewModel.shared.currentUser {
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
    // BookDetailView에 전달할 User를 가져오는 메서드
    // User 반환
    private func user(for book: Book) -> User {
        // book.ownerID == user.id 일치 확인 후 값 return
        if let user = users.first(where: { $0.id == book.ownerID }) {
            return user
        }
        // 일치값 없으면 일단 그냥 샘플 불러오게 처리
        return User(id: "정보 없음", nickName: "정보 없음", address: "정보 없음")
    }
    
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
    }
}
