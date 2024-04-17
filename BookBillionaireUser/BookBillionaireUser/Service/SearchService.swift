//
//  SearchService.swift
//  BookBillionaireUser
//
//  Created by 홍승표 on 4/15/24.
//

import Foundation
import BookBillionaireCore


class SearchService: ObservableObject {
    @Published var searchBook: String = ""
    @Published var filteredBooks: [Book] = []
    @Published var recentSearches: [String] = UserDefaults.standard.stringArray(forKey: "RecentSearches") ?? []
    private let bookService = BookService.shared
    private let userService = UserService.shared
    
    // 검색어 저장
    func saveSearchHistory() {
        if !searchBook.isEmpty && !recentSearches.contains(searchBook) {
            recentSearches.append(searchBook)
            // 최근 검색어 UserDefaults에 저장
            UserDefaults.standard.set(recentSearches, forKey: "RecentSearches")
        }
    }
    
    // 서치바 필터링 책검색 함수
    // 서비스 데이터(Back)를 모델에 가져와 뷰(Front)에 적용
    func searchBooksByTitle(title: String) {
        Task {
            let filteredResults = await bookService.searchBooksByTitle(title: searchBook)
            
            DispatchQueue.main.async {
                self.filteredBooks = filteredResults
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
    
    
    // BookDetailView에 전달할 User를 가져오는 메서드
    // User 반환
    func user(for book: Book) -> User {
        // book.ownerID == user.id 일치 확인 후 값 return
        if let user = userService.users.first(where: { $0.id == book.ownerID }) {
            return user
        }
        // 일치값 없으면 일단 그냥 샘플 불러오게 처리
        return User(id: "정보 없음", nickName: "정보 없음", address: "정보 없음")
    }
}
