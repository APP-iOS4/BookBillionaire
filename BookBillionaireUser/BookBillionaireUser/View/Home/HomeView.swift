//
//  HomeView.swift
//  BookBillionaireUser
//
//  Created by Woo Sung jong on 4/3/24.
//

import SwiftUI
import BookBillionaireCore



struct HomeView: View {
    let bookService = BookService.shared
    @State private var books: [Book] = []
    @State private var menuTitle: BookCategory = .hometown
    @State private var isShowingBottomSheet: Bool = false
    var body: some View {
        NavigationStack {
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
                    Button {
                        menuTitle = menu
                    } label: {
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
                    
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach(books, id: \.self) { book in
                            HStack(alignment: .top, spacing: 0) {
                                NavigationLink(value: book) {
                                    
                                    HStack(alignment: .center) {
                                        if book.thumbnail == "default" || book.thumbnail == "" {
                                            Image("default")
                                                .resizable()
                                                .frame(width: 100, height: 120)
                                                .background(Color.gray)
                                        } else {
                                            AsyncImage(url: URL(string: book.thumbnail)){ image in
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
                                .navigationDestination(for: Int.self) { value in
                                    BookDetailView(book: Book.sample, user: User.sample)
                                }
                                
                                .foregroundStyle(.primary)
                                Spacer()
                                
                                Button {
                                    isShowingBottomSheet.toggle()
                                    
                                } label: {
                                    Image(systemName: "ellipsis")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 17)
                                        .foregroundStyle(.gray.opacity(0.2))
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
            .onAppear {
                fetchBooks()
                print(books)
            }
        }
        .padding()
        
    }
    private func fetchBooks() {
        Task{
            books = await bookService.loadBooks()
        }
    }
}


#Preview {
    HomeView()
}
