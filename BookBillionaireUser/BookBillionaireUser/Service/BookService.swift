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
}


