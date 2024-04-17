//
//  SearchService.swift
//  BookBillionaireUser
//
//  Created by 홍승표 on 4/15/24.
//

import Foundation
import FirebaseFirestore
import BookBillionaireCore


class SearchService: ObservableObject {
    @Published var searchBook: String = ""
    @Published var filteredBooks: [Book] = []
    @Published var isSearching = false
    @Published var recentSearches: [String] = UserDefaults.standard.stringArray(forKey: "RecentSearches") ?? []
   
    private let bookRef = Firestore.firestore().collection("books")
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
            let filteredResults = await self.searchBooksByTitle(title: searchBook)
            
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
