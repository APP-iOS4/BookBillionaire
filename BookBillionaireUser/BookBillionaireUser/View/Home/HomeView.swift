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
    @EnvironmentObject var bookService: BookService
    @EnvironmentObject var userService: UserService
    @EnvironmentObject var authViewModel: AuthViewModel
    @AppStorage("recentlyPic") var recentlyPic: String = ""
    
    // 메뉴에 따라 필터로 책 불러오기
    var filteredBooks: [Book] {
        return bookService.filterByCategory(menuTitle)
    }
    var body: some View {
        VStack {
            // 헤더 & 서치
            HStack(alignment: .center) {
                Image("applogoShortcut")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("BOOK BILLIONAIRE")
                    .foregroundStyle(.accent)
                
                Spacer()
                
                NavigationLink(destination: BookSearchView()) {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20)
                }
            }
            ScrollView(showsIndicators: false) {
                //홈 배너
                HomePagingView()
                    .frame(height: 200)
                    .padding(.top)
                
                // 메뉴 버튼
                MenuScrollView(menuTitle: $menuTitle)
                    .padding(.vertical, 20)
                
                // 리스트
                // 메뉴 타이틀
                VStack(alignment: .leading) {
                    Text("\(menuTitle.rawValue)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.bottom, 12)
                    // 책 리스트
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach(filteredBooks, id: \.self) { book in
                            HStack(alignment: .top, spacing: 0) {
                                NavigationLink(value: book) {
                                    HStack(alignment: .center) {
                                        BookItem(book: book)
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
                                        .frame(width: 17, height: 20)
                                        .foregroundStyle(.gray.opacity(0.4))
                                        .rotationEffect(.degrees(90))
                                }
                            }
                            
                            Divider()
                                .background(Color.gray)
                                .padding(.vertical, 10)
                        }
                        .navigationDestination(for: Book.self) { book in
                            BookDetailView(book: book, user: userService.loadUserByID(book.ownerID))
                        }
                    }
                }
            }
        }
        .padding()
        .onAppear {
            userService.fetchUsers()
        }
        .onReceive(AuthViewModel.shared.$state) { _ in
            userService.currentUser = userService.loadUserByID(authViewModel.currentUser?.uid ?? "")
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(BookService())
        .environmentObject(UserService())
        .environmentObject(AuthViewModel())
}
