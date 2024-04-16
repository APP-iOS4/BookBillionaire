//
//  HomeView.swift
//  BookBillionaireUser
//
//  Created by 홍승표 on 11/4/24.
//

import SwiftUI
import BookBillionaireCore

struct HomeView: View {
    @State private var menuTitle: BookCategory = .hometown
    @State private var isShowingMenuSet: Bool = false
    @StateObject private var bookService = BookService.shared
    @StateObject private var userService = UserService.shared
    let searchService = SearchService()
    
    var body: some View {
        VStack {
            // 헤더 & 서치
            HStack(alignment: .center) {
                Text("BOOK BILLINAIRE")
                    .font(.largeTitle)
                    .foregroundStyle(.accent)
                
                Spacer()
                
                NavigationLink(destination: BookSearchView()) {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20)
                }
            }
            //홈 배너
            HomePagingView()
                .frame(height: 200)
            
            // 메뉴 버튼
            HStack(alignment: .center) {
                ForEach(BookCategory.allCases, id: \.self) { menu in
                    Button{
                        menuTitle = menu
                        bookService.fetchBooks(menuTitle: menu)
                        
                    } label: {
                        Text("\(menu.buttonTitle)")
                            .fontWeight(menuTitle == menu ? .bold : .regular)
                            .foregroundStyle(menuTitle == menu ? .white : .accentColor)
                            .minimumScaleFactor(0.5)
                    }
                    .padding(10)
                    .background(menuTitle == menu ? Color("AccentColor") : Color("SecondColor").opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .fixedSize()
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
                        ForEach(bookService.books, id: \.self) { book in
                            HStack(alignment: .top, spacing: 0) {
                                NavigationLink(value: book) {
                                    HStack(alignment: .center) {
                                        BookListRowView(book: book)
                                    }
                                }
                                .foregroundStyle(.primary)
                                Spacer()
                                
                                // 설정 버튼
                                Menu {
                                    Button {
                                        
                                    } label: {
                                        Label("게시물 숨기기", systemImage: "eye.slash")
                                    }
                                    
                                } label: {
                                    Image(systemName: "ellipsis")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 17)
                                        .foregroundStyle(.gray.opacity(0.4))
                                        .rotationEffect(.degrees(90))
                                }
                                .padding(.top, 10)

                            }
                            Divider()
                                .background(Color.gray)
                                .padding(.vertical, 10)
                        }
                        .navigationDestination(for: Book.self) { book in
                            BookDetailView(book: book, user: searchService.user(for: book))
                        }
                    }
                }
            }
        }
        .padding()
        // 책 불러오기
        .onAppear {
            bookService.fetchBooks(menuTitle: menuTitle)
            userService.fetchUsers()
        }
    }

}

#Preview {
    HomeView()
}
