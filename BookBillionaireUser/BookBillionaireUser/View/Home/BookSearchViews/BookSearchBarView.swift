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
    // 검색 viewModel
    @StateObject private var searchService = SearchService()
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                TextField("책 이름을 입력해주세요", text: $searchService.searchBook)
                    .keyboardType(.webSearch)
                    .textFieldStyle(.roundedBorder)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("AccentColor"),lineWidth: 1)
                        // 텍스트 삭제 버튼
                        HStack {
                            Spacer()
                            if !searchService.searchBook.isEmpty {
                                Button {
                                    searchService.searchBook = ""
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(.gray)
                                }
                            }
                        }
                        .padding(.trailing, 5)
                    }
                    .onChange(of: searchService.searchBook) { _ in
                        searchService.isSearching = false
                     }

                
                Button {
                    if !searchService.searchBook.isEmpty {
                        searchService.saveSearchHistory()
                        searchService.searchBooksByTitle(title: searchService.searchBook)
                        
                        searchService.isSearching = true
                    }
                    
                } label: {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.primary)
                }
            }
            .padding(.bottom, 20)
            
            
            // 뷰 전환 - 검색 목록 & 최근 검색어
            if searchService.isSearching || searchService.searchBook.isEmpty {
                BookSearchListView(searchBook: $searchService.searchBook, filteredBooks: $searchService.filteredBooks)
            } else {
                RecentSearchView(searchBook: $searchService.searchBook)
            }
        }
    }

}

#Preview {
    BookSearchBarView(searchBook: .constant("원도"), filteredBooks: .constant([Book(owenerID: "", title: "", contents: "", authors: [""], rentalState: .rentalAvailable)]))
}

