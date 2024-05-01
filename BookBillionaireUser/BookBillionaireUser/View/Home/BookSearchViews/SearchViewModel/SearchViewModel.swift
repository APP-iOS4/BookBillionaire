//
//  SearchService.swift
//  BookBillionaireUser
//
//  Created by 홍승표 on 4/15/24.
//

import Foundation
import FirebaseFirestore
import BookBillionaireCore


class SearchViewModel: ObservableObject {
    @Published var searchBookText: String = ""
    @Published var isSearching = false
    @Published var recentSearches: [String] = UserDefaults.standard.stringArray(forKey: "RecentSearches") ?? []
    
    // 검색어 저장
    func saveSearchHistory() {
        if !searchBookText.isEmpty && !recentSearches.contains(searchBookText) {
            recentSearches.append(searchBookText)
            // 최근 검색어 UserDefaults에 저장
            UserDefaults.standard.set(recentSearches, forKey: "RecentSearches")
        }
    }
    
    // 검색어 되돌리기
    func removeSearchHistory(search: String) {
        if let index = recentSearches.firstIndex(of: search) {
            recentSearches.remove(at: index)
            // 최근 검색어 UserDefaults에서 업데이트
            UserDefaults.standard.set(recentSearches, forKey: "RecentSearches")
        }
    }
    
    // 검색어 전체 삭제
    func removeAllSearchHistory() {
        recentSearches.removeAll()
        // 최근 검색어 UserDefaults에서 업데이트
        UserDefaults.standard.set(recentSearches, forKey: "RecentSearches")
    }
}
