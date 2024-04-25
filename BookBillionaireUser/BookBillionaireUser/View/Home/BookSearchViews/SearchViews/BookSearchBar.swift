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
            if isSearching || searchViewModel.searchBookText.isEmpty {
                bookSearchList
            } else {
                recentSearchList
            }
        }
        .navigationTitle("책 검색하기")
    }
    
}

//#Preview {
//    BookSearchBar(searchBookText: .constant(""), filteredBooks: .constant([Book(ownerID: "", title: "", contents: "", authors: [""], rentalState: .rentalAvailable)]), selectedTab: <#Binding<ContentView.Tab>#>)
//        .environmentObject(UserService())
//}

extension BookSearchBar {
    var recentSearchList: some View {
        VStack(spacing: 20) {
            // 최근 검색어 표시
            HStack {
                Text("최근 검색어")
                    .font(.title3)
                    .foregroundStyle(.accent)
                Spacer()
            }
            
            if searchViewModel.recentSearches.isEmpty {
                Text("최근에 검색한 기록이 없습니다.")
                    .foregroundColor(.gray)
                
            } else {
                LazyVStack {
                    ForEach(searchViewModel.recentSearches.reversed(), id: \.self) { search in
                        HStack {
                            Text("\(search)")
                                .foregroundColor(.primary)
                            Spacer()
                            Button {
                                searchViewModel.removeSearchHistory(search: search)
                            } label: {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundStyle(.gray)
                            }
                        }
                        .onTapGesture {
                            searchViewModel.searchBookText = search
                        }
                        Divider()
                    }
                }
            }
        }
    }
}

extension BookSearchBar {
    var bookSearchList: some View {
        VStack(spacing: 20) {
            HStack {
                Text("검색된 책 목록")
                    .font(.title3)
                    .foregroundStyle(.accent)
                Spacer()
            }
            
            if filteredBooks.isEmpty {
                Text("검색한 책의 결과가 없습니다")
                    .foregroundColor(.gray)
                
            } else {
                LazyVStack(alignment: .leading, spacing: 10) {
                    ForEach(filteredBooks) { book in
                        NavigationLink {
                            BookDetailView(book: book, user: userService.loadUserByID(book.ownerID), selectedTab: $selectedTab)
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