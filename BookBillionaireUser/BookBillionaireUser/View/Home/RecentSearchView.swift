//
//  RecentSearchView.swift
//  BookBillionaireUser
//
//  Created by 홍승표 on 4/11/24.
//

import SwiftUI

struct RecentSearchView: View {
    @Binding var searchBook: String
    @State private var recentSearches: [String] = UserDefaults.standard.stringArray(forKey: "RecentSearches") ?? []
    
    var body: some View {
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
    
    // 검색어 되돌리기
    func removeSearchHistory(search: String) {
        if let index = recentSearches.firstIndex(of: search) {
            // 최근 검색어 UserDefaults에서 업데이트
                        UserDefaults.standard.set(recentSearches, forKey: "RecentSearches")
            recentSearches.remove(at: index)
        }
    }
    
}

#Preview {
    RecentSearchView(searchBook: .constant("원도"))
}
