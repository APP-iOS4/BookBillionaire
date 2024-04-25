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
    @Binding var selectedTab: ContentView.Tab
    
    var filteredBooks: [Book] {
        return bookService.filterByCategory(menuTitle)
    }
    
    var body: some View {
        VStack {
            headerView
            
            ScrollView(showsIndicators: false) {
                HomeBanner()
                    .frame(height: 200)
                    .padding(.top)
                
                menuScrollView
                    .padding(.vertical, 20)
                
                bookListView
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
    HomeView(selectedTab: .constant(.home))
        .environmentObject(BookService())
        .environmentObject(UserService())
        .environmentObject(AuthViewModel())
}


extension HomeView {
    var headerView: some View {
        HStack(alignment: .center) {
            Image("mainPageLogo")
                .resizable()
                .scaledToFit()
                .padding(.trailing, 50)
            Spacer()
            
            NavigationLink(destination: BookSearchView(selectedTab: $selectedTab)) {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20)
            }
        }
    }
}

extension HomeView {
    var menuScrollView: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center) {
                    ForEach(BookCategory.allCases, id: \.self) { menu in
                        Button {
                                menuTitle = menu
                                proxy.scrollTo(menu, anchor: .center)
                        } label: {
                            Text("\(menu.buttonTitle)")
                                .fontWeight(menuTitle == menu ? .bold : .regular)
                                .foregroundStyle(menuTitle == menu ? .white : .black)
                                .minimumScaleFactor(0.5)
                                .frame(width: 70, height: 20)
                        }
                        .padding(10)
                        .background(menuTitle == menu ? Color("AccentColor") : Color("SecondColor").opacity(0.6))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
        }
    }
}

extension HomeView {
    var bookListView: some View {
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
                        // Menu {
                        //     Button {
                                
                        //     } label: {
                        //         Label("게시물 숨기기", systemImage: "eye.slash")
                        //     }
                        // } label: {
                        //     Image(systemName: "ellipsis")
                        //         .resizable()
                        //         .scaledToFit()
                        //         .frame(width: 17, height: 20)
                        //         .foregroundStyle(.gray.opacity(0.4))
                        //         .rotationEffect(.degrees(90))
                        // }
                    }
                    Divider()
                        .background(Color.gray)
                        .padding(.vertical, 10)
                }
                .navigationDestination(for: Book.self) { book in
                    BookDetailView(book: book, user: userService.loadUserByID(book.ownerID), selectedTab: $selectedTab)
                }
            }
        }
    }
}
