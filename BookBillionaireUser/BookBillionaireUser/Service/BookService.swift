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
    @Published var books: [Book] = []
    private let bookRef = Firestore.firestore().collection("books")
    
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
    
    /// 유저들이 등록한 모든 책을 다 가져오는 함수
    func loadBooks() async {
        do {
            let querySnapshot = try await bookRef.getDocuments()
            DispatchQueue.main.sync {
                books = querySnapshot.documents.compactMap { document -> Book? in
                    do {
                        let book = try document.data(as: Book.self)
                        return book
                    } catch {
                        print("Error decoding book: \(error)")
                        return nil
                    }
                }
            }
        } catch {
            print("Error fetching documents: \(error)")
        }
    }
    
    /// 책들 모두 패치
    func fetchBooks() {
        Task{
            await loadBooks()
        }
    }
    
    /// 책 owner ID로 책을 필터링 하는함수
    func filterByOwenerID(_ ownerID: String) -> [Book] {
        return books.filter { $0.ownerID == ownerID }
    }
    
    /// 책 ID로 책을 필터링 하는 함수
    func filterByBookID(_ bookID: String) -> [Book] {
        return books.filter { $0.id == bookID }
    }
    
    /// 카테고리 별 책 리스트 나열
    func filterByCategory(_ bookCategory: BookCategory) -> [Book] {
        return books.filter { $0.bookCategory == bookCategory }
    }
    
    /// 특정 책 삭제
    func deleteBook(_ book: Book) async {
        do {
            try await bookRef.document(book.id).delete()
            print("삭제완료")
        } catch {
            print("\(#function) Error removing document : \(error)")
        }
        self.fetchBooks()
    }
    
    // 렌탈 상황에 따른 상태 변경 함수
    func updateRentalState(_ bookID: String, rentalState: RentalStateType) async {
        let userRentalRef = bookRef.document(bookID)
        do {
            try await userRentalRef.updateData([
                "rentalState" : rentalState.rawValue
            ])
            print("렌탈 상황 변경 성공🧚‍♀️")
        } catch let error {
            print("\(#function) 렌탈정보 변경 실패했음☄️ \(error)")
        }
        self.fetchBooks()
    }
    
    /// 렌탈 ID 등록 및 삭제할 때 모두 이용가능
    /// 렌탈을 삭제하고 싶을 때는 deleteBookID 입력, 등록하고 싶을때는 registerBookID 입력
    func updateRental(deleteBookID: String?, registerBookID: String?, rental: Rental) async {
        if let deleteBookID {
            let userRentalRef = bookRef.document(deleteBookID)
            do {
                try await userRentalRef.updateData([
                    "rental" : ""
                ])
                print("렌탈 삭제성공🧚‍♀️")
            } catch {
                print("\(#function) 렌탈삭제 실패했음☄️ \(error)")
            }
            self.fetchBooks()
        }
        if let registerBookID {
            let userRentalRef = bookRef.document(registerBookID)
                do {
                    try await userRentalRef.updateData([
                        "rental" : rental.id
                    ])
                    print("렌탈 등록성공🧚‍♀️")
                } catch {
                    print("\(#function) 렌탈등록 실패했음☄️ \(error)")
                }
                self.fetchBooks()
            }
    }
    
    /// 책의 카테고리를 업데이트 하는 함수
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
        self.fetchBooks()
    }
}
