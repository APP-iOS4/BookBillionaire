//
//  UserService.swift
//  BookBillionaireUser
//
//  Created by YUJIN JEON on 4/3/24.
//

import Foundation
import FirebaseFirestore
import BookBillionaireCore

class BookService: ObservableObject {
    static let shared = BookService() // 싱글턴 인스턴스
    var books: [Book]
    private let bookRef = Firestore.firestore().collection("books")
    
    private init() {
        books = []
    } // 외부에서 인스턴스화 방지를 위한 private 초기화
    
    /// 책을 등록하는 함수
    func registerBook(_ book: Book) -> Bool {
        do {
            try bookRef.document(book.id).setData(from: book)
            let userRef = Firestore.firestore().collection("User").document(book.ownerID)
            userRef.updateData([
                "myBooks": FieldValue.arrayUnion([book.id])
            ])
            return true
        } catch let error {
            print("\(#function) 책 저장 함수 오류: \(error)")
            return false
        }
    }
    
    ///대량으로 책 업로드 하는 함수
    func setAllBook(books: [Book]) {
        for book in books {
            if self.registerBook(book) {
                print("set OK")
            } else {
                print("set fail")
            }
        }
    }
    
    /// 유저들이 등록한 모든 책을 다 가져오는 함수
    func loadBooks() async -> [Book] {
        var resultBooks: [Book] = []
        do {
            let querySnapshot = try await bookRef.getDocuments()
            resultBooks = querySnapshot.documents.compactMap { document -> Book? in
                do {
                    let book = try document.data(as: Book.self)
                    return book
                } catch {
                    print("Error decoding book: \(error)")
                    return nil
                }
            }
        } catch {
            print("Error fetching documents: \(error)")
        }
        print(resultBooks)
        return resultBooks
    }
    
    /// 책 owner ID로 책을 불러오는 함수
    func loadBookByID(_ ownerID: String) async -> [Book]{
        var resultBooks: [Book] = []
        do {
            let querySnapshot = try await bookRef.whereField("ownerID", isEqualTo: ownerID).getDocuments()
            resultBooks = querySnapshot.documents.compactMap { document -> Book? in
                do {
                    let book = try document.data(as: Book.self)
                    return book
                } catch {
                    print("Error decoding book: \(error)")
                    return nil
                }
            }
        } catch {
            print("Error fetching documents: \(error)")
        }
        return resultBooks
    }
    
    /// 특정 책 삭제
    func deleteBook(_ book: Book) async {
        do {
            try await bookRef.document(book.id).delete()
            print("삭제완료")
        } catch {
            print("\(#function) Error removing document : \(error)")
        }
    }
    
    func updateRentalState(_ bookID: String, rentalState: RentalStateType) async {
        let userRentalRef = bookRef.document(bookID)
        do {
            try await userRentalRef.updateData([
                "rentalState" : rentalState.rawValue
            ])
            print("렌탈상황 변경 성공🧚‍♀️")
        } catch let error {
            print("\(#function) 렌탈정보 변경 실패했음☄️ \(error)")
        }
    }
    
    func updateBookCategory(_ bookID: String, bookCategory: BookCategory) async {
        let userRentalRef = bookRef.document(bookID)
        do {
            try await userRentalRef.updateData([
                "bookCategory" : bookCategory.rawValue
            ])
            print("카테고리 변경 성공🧚‍♀️")
        } catch let error {
            print("\(#function) 카테고리 변경 실패했음☄️ \(error)")
        }
    }
    
    // 카테고리 별 책 리스트 나열
    func filteredLoadBooks(bookCategory: BookCategory) async -> [Book] {
        var filterdBooks: [Book] = []
        do {
            let querySnapshot = try await bookRef.whereField("bookCategory", isEqualTo: bookCategory.rawValue).getDocuments()
            filterdBooks = querySnapshot.documents.compactMap { document -> Book? in
                do {
                    let book = try document.data(as: Book.self)
                    return book
                } catch {
                    print("Error decoding book: \(error)")
                    return nil
                }
            }
        } catch {
            print("Error fetching documents: \(error)")
        }
        print(filterdBooks)
        return filterdBooks
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


