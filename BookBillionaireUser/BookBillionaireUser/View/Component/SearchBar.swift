//
//  SearchBar.swift
//  BookBillionaireUser
//
//  Created by Woo Sung jong on 4/3/24.
//

import SwiftUI
import BookBillionaireCore

struct SearchBar: View {
    @Binding var searchBook: String
    @State private var isSearching = false
    @State private var recentSearches: [String] = UserDefaults.standard.stringArray(forKey: "RecentSearches") ?? []
    let bookService = BookService.shared
    @State private var filteredBooks: [Book] = []
 
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                TextField("책 이름을 입력해주세요", text: $searchBook)
                    .keyboardType(.webSearch)
                    .textFieldStyle(.roundedBorder)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("AccentColor"),lineWidth: 1)
                    }
                
                if !searchBook.isEmpty {
                    Button {
                        searchBook = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.gray)
                    }
                }
                
                Button {
                    if !searchBook.isEmpty {
                        saveSearchHistory()
                        searchBooksByTitle(title: searchBook)
                    }
                    
                } label: {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.primary)
                }
            }
            .padding(.bottom, 20)
            
            
            // 뷰 전환 - 검색 목록 & 최근 검색어
            if isSearching || searchBook.isEmpty {
                searchListView
            } else {
                recentSearchView
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
    // 검색어 되돌리기
    func removeSearchHistory(search: String) {
        if let index = recentSearches.firstIndex(of: search) {
            // 최근 검색어 UserDefaults에서 업데이트
                        UserDefaults.standard.set(recentSearches, forKey: "RecentSearches")
            recentSearches.remove(at: index)
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
    SearchBar(searchBook: .constant(""))
}

// 최근 검색어
extension SearchBar {
    var recentSearchView: some View {
        VStack(spacing: 20) {
            // 최근 검색어 표시
            HStack {
                Text("최근 검색어")
                    .font(.title3)
                    .foregroundStyle(.accent)
                Spacer()
            }
            
            if recentSearches.isEmpty {
                Text("검색 결과 없음")
                    .foregroundColor(.gray)
                
            } else {
                LazyVStack {
                    ForEach(recentSearches.reversed(), id: \.self) { search in
                        HStack {
                            Text("\(search)")
                                .foregroundColor(.primary)
                            Spacer()
                            
                            Button(action: {
                                removeSearchHistory(search: search)
                            }, label: {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundStyle(.gray)
                            })
                        }
                        Divider()
                    }
                }
            }
        }
    }
}
// 책 검색 목록
extension SearchBar {
    var searchListView: some View {
        VStack(spacing: 20) {
            HStack {
                Text("검색된 책 목록")
                    .font(.title3)
                    .foregroundStyle(.accent)
                Spacer()
            }
            
            if filteredBooks.isEmpty {
                Text("검색한 결과가 없습니다")
                
            } else {
                LazyVStack(alignment: .leading, spacing: 10) {
                    ForEach(filteredBooks) { book in
                        BookListRowView(book: book)
                    }
                }
            }
        }
    }
}
