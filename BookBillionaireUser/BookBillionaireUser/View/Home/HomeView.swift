//
//  HomeView.swift
//  BookBillionaireUser
//
//  Created by Woo Sung jong on 4/3/24.
//

import SwiftUI
import BookBillionaireCore



struct HomeView: View {
    @State private var books: [Book] = []
    @State private var users: [User] = []
    @State private var menuTitle: BookCategory = .hometown
    @State private var isShowingBottomSheet: Bool = false
    let bookService = BookService.shared
    let userService = UserService.shared

    
    var body: some View {
        NavigationStack {
            // 헤더 & 서치
            HStack(alignment: .center) {
                Text("BOOK BILLINAIRE")
                    .font(.largeTitle)
                
                Spacer()
                
                NavigationLink(destination: BookSearchView()) {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20)
                }
            }
            .padding(.bottom, 12)
            
            // 메뉴 버튼
            HStack(alignment: .center) {
                ForEach(BookCategory.allCases, id: \.self) { menu in
                    Button{
                        menuTitle = menu
                    }
                label: {
                        Text("\(menu.buttonTitle)")
                            .fontWeight(menuTitle == menu ? .bold : .regular)
                    }
                }
            }
            .padding(.bottom, 12)
            
            // 리스트
            ScrollView(showsIndicators: false) {
                // 메뉴 타이틀
                VStack(alignment: .leading) {
                    Text("\(menuTitle.rawValue)")
                        .font(.title2)
                        .padding(.bottom, 12)
                    // 책 리스트
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach(books, id: \.self) { book in
                            HStack(alignment: .top, spacing: 0) {
                                NavigationLink(value: book) {
                                    HStack(alignment: .center) {
                                        BookListRowView(book: book)
                                            .padding(.bottom, 12)
                                    }
                                }
                                .navigationDestination(for: Book.self) { book in
                                    BookDetailView(book: book, user: user(for: book))
                                }
                                .foregroundStyle(.primary)
                                
                                Spacer()
                                // 설정 버튼
                                Button {
                                    isShowingBottomSheet.toggle()
                                    
                                } label: {
                                    Image(systemName: "ellipsis")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 17)
                                        .foregroundStyle(.gray.opacity(0.4))
                                        .rotationEffect(.degrees(90))
                                }
                                .padding(.top, 10)
                                .sheet(isPresented: $isShowingBottomSheet) {
                                    BottomSheet(isShowingSheet: $isShowingBottomSheet)
                                        .presentationDetents([.fraction(0.2)])
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding()
        // 책 불러오기
        .onAppear {
            fetchBooks()
            fetchUsers()
        }
    }
    // 책 데이터 호출
    func fetchBooks() {
        Task {
            books = await bookService.loadBooks()
        }
    }
    // 책 소유자 유저 데이터 호출
    func fetchUsers() {
        Task {
            users = await userService.loadUsers()
        }
    }
    
    // BookDetailView에 전달할 User를 가져오는 메서드
    // User 반환
    func user(for book: Book) -> User {
        // book.ownerID == user.id 일치 확인 후 값 return
        if let ownerId = book.ownerID {
            if let user = users.first(where: { $0.id == ownerId }) {
                return user
            }
        }
        // 일치값 없으면 일단 그냥 샘플 불러오게 처리
        // 추후 협의후 수정예정
        return User.sample
    }
}

#Preview {
    HomeView()
}
