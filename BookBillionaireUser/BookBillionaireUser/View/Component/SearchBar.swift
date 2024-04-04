//
//  SearchBar.swift
//  BookBillionaireUser
//
//  Created by Woo Sung jong on 4/3/24.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchBook: String
    @State private var isSearching = false
    @State private var recentSearches: [String] = []
    
    var body: some View {
        VStack {
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
                    }
                    
                } label: {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.primary)
                }
            }
            recentSearchView
            
        }
    }
    // 검색어 저장
    func saveSearchHistory() {
        if !searchBook.isEmpty {
            recentSearches.append(searchBook)
            // 추가 후에 검색어를 초기화합니다.
            searchBook = ""
        }
    }
    //검색어 되돌리기
    func removeSearchHistory(search: String) {
        if let index = recentSearches.firstIndex(of: search) {
            recentSearches.remove(at: index)
        }
    }
}

#Preview {
    SearchBar(searchBook: .constant(""))
}

extension SearchBar {
    var recentSearchView: some View {
        VStack {
            // 최근 검색어 표시
            VStack(alignment: .leading) {
                Text("최근 검색어")
                    .font(.headline)
                    .padding(.top)
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
                .padding()
            }
        }
    }
}
