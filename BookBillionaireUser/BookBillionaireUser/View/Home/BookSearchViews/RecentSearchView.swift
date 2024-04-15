//
//  RecentSearchView.swift
//  BookBillionaireUser
//
//  Created by 홍승표 on 4/11/24.
//

import SwiftUI

struct RecentSearchView: View {
    @Binding var searchBook: String
    @StateObject private var searchService = SearchService()
    
    var body: some View {
        VStack(spacing: 20) {
            // 최근 검색어 표시
            HStack {
                Text("최근 검색어")
                    .font(.title3)
                    .foregroundStyle(.accent)
                Spacer()
            }
            
            if searchService.recentSearches.isEmpty {
                Text("검색 결과 없음")
                    .foregroundColor(.gray)
                
            } else {
                LazyVStack {
                    ForEach(searchService.recentSearches.reversed(), id: \.self) { search in
                        HStack {
                            Text("\(search)")
                                .foregroundColor(.primary)
                            Spacer()
                            
                            Button(action: {
                                searchService.removeSearchHistory(search: search)
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

#Preview {
    RecentSearchView(searchBook: .constant("원도"))
}
