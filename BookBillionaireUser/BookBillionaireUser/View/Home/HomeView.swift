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
    @Namespace private var scrollID // 스크롤 이동할 위치 찍어주기
    var filteredBooks: [Book] {
        return bookService.filterByCategory(menuTitle)
    }
    
    var body: some View {
        ScrollViewReader { scrollView in
            ZStack {
                VStack {
                    headerView
                    ScrollView(showsIndicators: false) {
                        HomeBanner()
                            .frame(height: UIDevice.current.userInterfaceIdiom == .pad ? 500 : 200)
                            .padding(.top)
                            .id(scrollID)
                        menuScrollView
                            .padding(.vertical, 20)
                        bookListView
                    }
                }
                //스크롤 위로 이동 버튼
                    Image(systemName: "arrow.up")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .padding(10)
                        .background(Color.accentColor)
                        .foregroundStyle(.white)
                        .clipShape(Circle())
                        .onTapGesture {
                            scrollView.scrollTo(scrollID, anchor: .top)
                        }
                        .offset(x: UIScreen.main.bounds.width/2 - 40, y: UIScreen.main.bounds.height/2 - 130)
                }
        }
        .padding()
        .onAppear {
            userService.fetchUsers()
            Task {
                await bookService.loadBooks()
            }
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

//MARK: - 헤더
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
//MARK: - 메뉴 버튼
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
//MARK: - 카테고리별 메뉴 리스트
extension HomeView {
    var bookListView: some View {
        VStack(alignment: .leading) {
            Text("\(menuTitle.rawValue)")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.bottom, 12)
            // 책 리스트
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(filteredBooks, id: \.self) { book in
                    HStack(alignment: .top, spacing: 0) {
                        NavigationLink(value: book) {
                            HStack(alignment: .center) {
                                BookItem(book: book)
                            }
                        }
                        .foregroundStyle(.primary)
                        Spacer()
                    }
                    Divider()
                        .background(Color.gray)
                        .padding(.vertical, 10)
                }
                .navigationDestination(for: Book.self) { book in
                    BookDetailView(book: book, user: userService.loadUserByID(book.ownerID), bookDetailViewModel: BookDetailViewModel(), selectedTab: $selectedTab)
                }
                
            }
        }
    }
}
