//
//  SearchBar.swift
//  BookBillionaireUser
//
//  Created by 홍승표 on 11/4/24.
//

import SwiftUI
import BookBillionaireCore

struct BookSearchBar: View {
    @State var isSearching = false
    @Binding var searchBookText: String
    @Binding var filteredBooks: [Book]
    @StateObject private var bookDetailViewModel = BookDetailViewModel(book: Book(), user: User(), rental: Rental(), rentalService: RentalService())
    @StateObject private var searchViewModel = SearchViewModel()
    @EnvironmentObject var userService: UserService
    @Binding var selectedTab: ContentView.Tab
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                TextField("책 이름을 입력해주세요", text: $searchViewModel.searchBookText)
                    .keyboardType(.webSearch)
                    .textFieldStyle(.roundedBorder)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("AccentColor"),lineWidth: 1)
                        // 텍스트 삭제 버튼
                        HStack {
                            Spacer()
                            if !searchViewModel.searchBookText.isEmpty {
                                Button {
                                    searchViewModel.searchBookText = ""
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(.gray)
                                }
                            }
                        }
                        .padding(.trailing, 5)
                    }
                    .onChange(of: searchViewModel.searchBookText) { _ in
                        isSearching = false
                    }
                
                Button {
                    if !searchViewModel.searchBookText.isEmpty {
                        searchViewModel.saveSearchHistory()
                        
                        Task {
                            let searchResults = await searchViewModel.searchBooksByTitle(title: searchViewModel.searchBookText)
                            DispatchQueue.main.async {
                                self.filteredBooks = searchResults // filteredBooks에 결과 할당
                                self.isSearching = true
                            }
                        }
                    }
                    
                } label: {
                    Image(systemName: "magnifyingglass")
                }
                
            }
            .padding(.bottom, 20)
            
            // 뷰 전환 - 검색 목록 & 최근 검색어
            if isSearching {
                bookSearchList
            } else if searchViewModel.recentSearches.isEmpty {
                VStack(spacing: 10) {
                    Spacer()
                    Circle()
                        .stroke(lineWidth: 3)
                        .overlay {
                            Image(systemName: "magnifyingglass")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(20)
                        }
                        .frame(width: 70, height: 70)
                    
                    Text("최근 검색어 내역이 없습니다.")
                    Spacer()
                }
                .font(.title3)
                .fontWeight(.medium)
                .foregroundStyle(.gray)
            } else {
                recentSearchList
            }

           
        }
        .navigationTitle("책 검색하기")
    }
    
}

#Preview {
    BookSearchBar(searchBookText: .constant(""), filteredBooks: .constant([Book(ownerID: "", ownerNickname: "", title: "", contents: "", authors: [""], rentalState: .rentalAvailable)]), selectedTab: .constant(.home))
        .environmentObject(UserService())
}

extension BookSearchBar {
    var recentSearchList: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                // 최근 검색어 표시
                HStack {
                    Text("최근 검색어")
                        .font(.title3)
                        .foregroundStyle(.accent)
                    Spacer()
                    Text("전체 삭제")
                        .font(.body)
                        .foregroundStyle(.accent)
                        .onTapGesture {
                            searchViewModel.removeAllSearchHistory()
                            searchViewModel.searchBookText = ""
                        }
                }
                .padding(.bottom, 20)
                if !searchViewModel.recentSearches.isEmpty {
                    ForEach(searchViewModel.recentSearches.reversed(), id: \.self) { search in
                        HStack(alignment: .bottom) {
                            Image(systemName: "magnifyingglass.circle.fill")
                                .foregroundStyle(.gray.opacity(0.5))
                            Text("\(search)")
                                .foregroundStyle(.primary)
                            Spacer()
                            Button {
                                searchViewModel.removeSearchHistory(search: search)
                            } label: {
                                Image(systemName: "xmark")
                                    .foregroundColor(.gray.opacity(0.5))
                            }
                        }
                        .padding(.bottom, 10)
                        .onTapGesture {
                            searchViewModel.searchBookText = search
                        }
                    }
                }
            }
        }
    }
}

extension BookSearchBar {
    var bookSearchList: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("검색된 책 목록")
                        .font(.title3)
                        .foregroundStyle(.accent)
                    Spacer()
                }
                
                if !filteredBooks.isEmpty {
                    ForEach(filteredBooks) { book in
                        NavigationLink {
                            let bookDetailViewModel = BookDetailViewModel(book: book, user: userService.loadUserByID(book.ownerID), rental: Rental(), rentalService: RentalService())
                            
                            BookDetailView(book: book, user: userService.loadUserByID(book.ownerID), bookDetailViewModel: bookDetailViewModel, selectedTab: $selectedTab)
                        } label: {
                            BookItem(book: book)
                        }
                        
                    }
                    .foregroundStyle(.primary)
                }
            }
        }
    }
}
