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
   
    private let bookRef = Firestore.firestore().collection("books")
    
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
    

    // 책 검색 필터 (서치바)
    func searchBooksByTitle(title: String) async -> [Book] {
        var searchResult: [Book] = []
        do {
            let querySnapshot = try await bookRef.getDocuments()
            searchResult = querySnapshot.documents.compactMap { document -> Book? in
                do {
                    let book = try document.data(as: Book.self)
                    // 책 제목에 검색어의 각 문자를 포함하는지 확인
                    let titleCharacters = Array(title)
                    
                    let contained = titleCharacters.allSatisfy { character in
                        return (book.title).localizedCaseInsensitiveContains(String(character))
                    }
                    
                    if contained {
                        return book
                    } else {
                        return nil
                    }
                } catch {
                    print("디코딩 오류: \(error)")
                    return nil
                }
            }
            print("검색 결과: \(searchResult)")
            print("부분 일치 검색 결과: \(searchResult)")
        } catch {
            print("문서를 가져오는 중에 오류가 발생했습니다: \(error)")
        }
        return searchResult
    }
}
