//
//  SearchBar.swift
//  BookBillionaireUser
//
//  Created by 홍승표 on 11/4/24.
//

import SwiftUI
import BookBillionaireCore

struct BookSearchBarView: View {
    @Binding var searchBook: String
    @Binding var filteredBooks: [Book]
    @State private var isSearching = false
    @State private var recentSearches: [String] = UserDefaults.standard.stringArray(forKey: "RecentSearches") ?? []
    let bookService = BookService.shared
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                TextField("책 이름을 입력해주세요", text: $searchBook)
                    .keyboardType(.webSearch)
                    .textFieldStyle(.roundedBorder)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("AccentColor"),lineWidth: 1)
                        // 텍스트 삭제 버튼
                        HStack {
                            Spacer()
                            if !searchBook.isEmpty {
                                Button {
                                    searchBook = ""
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(.gray)
                                }
                            }
                        }
                        .padding(.trailing, 5)
                    }
                    .onChange(of: searchBook) { _ in
                         isSearching = false
                     }

                
                Button {
                    if !searchBook.isEmpty {
                        saveSearchHistory()
                        searchBooksByTitle(title: searchBook)
                        isSearching = true
                    }
                    
                } label: {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.primary)
                }
            }
            .padding(.bottom, 20)
            
            
            // 뷰 전환 - 검색 목록 & 최근 검색어
            if isSearching || searchBook.isEmpty {
                BookSearchListView(searchBook: $searchBook, filteredBooks: $filteredBooks)
            } else {
                RecentSearchView(searchBook: $searchBook)
            }
        }
    }
    
    // 검색어 저장
    func saveSearchHistory() {
        if !searchBook.isEmpty && !recentSearches.contains(searchBook) {
              recentSearches.append(searchBook)
            // 최근 검색어 UserDefaults에 저장
            UserDefaults.standard.set(recentSearches, forKey: "RecentSearches")
        }
    }
    
    // 서치바 필터링 책검색 함수
    func searchBooksByTitle(title: String) {
        Task {
            filteredBooks = await bookService.searchBooksByTitle(title: searchBook)
        }
    }
}

#Preview {
    BookSearchBarView(searchBook: .constant(""), filteredBooks: .constant([]))
}

