//
//  RentalService.swift
//  BookBillionaireUser
//
//  Created by YUJIN JEON on 4/5/24.
//

import Foundation
import FirebaseFirestore
import BookBillionaireCore

class RentalService: ObservableObject {
    @Published var rentals: [Rental] = []
    private let rentalRef = Firestore.firestore().collection("rentals")
    /// 약속일정을 잡을 때 등록하는 함수
    /// book에 렌탈아이디도 박아줘야함
    func registerRental(_ rental: Rental) -> Bool {
        do {
            try rentalRef.document(rental.id).setData(from: rental)
            return true
        } catch let error {
            print("\(#function) 렌탈 저장 함수 오류: \(error)")
            return false
        }
    }
    
    func updateRental(_ rental: Rental) async {
        let rentaldocRef = rentalRef.document(rental.id)
        do {
            try await rentaldocRef.updateData([
                "rentalStartDay" : rental.rentalStartDay,
                "rentalEndDay" : rental.rentalEndDay,
                "map" : rental.map,
                "mapDetail" : rental.mapDetail,
                "latitude" : rental.latitude,
                "longitude" : rental.longitude
            ])
            print("렌탈 변경 성공🧚‍♀️")
        } catch let error {
            print("\(#function) 렌탈 변경 실패했음☄️ \(error)")
        }
    }
    
    func updateRentalTime(_ rentalID: String, rentalTime: Date) async {
        let rentaldocRef = rentalRef.document(rentalID)
        do {
            try await rentaldocRef.updateData([
                "rentalTime" : rentalTime,
            ])
            print("렌탈타임 변경 성공🧚‍♀️")
        } catch let error {
            print("\(#function) 렌탈타임 변경 실패했음☄️ \(error)")
        }
    }
    
    /// 렌탈 날짜를 불러오는 함수 -> 리턴값 튜플
    func getRentalDay(_ rentalID: String) async -> (Date, Date) {
        let rentaldocRef = rentalRef.document(rentalID)
        do {
            let rental = try await rentaldocRef.getDocument(as: Rental.self)
            return (rental.rentalStartDay, rental.rentalEndDay)
        } catch {
            print("렌탈 디코딩 에러 \(error)")
        }
        return (Date(), Date())
    }
    
    func deleteRentalFromBook(_ book: Book) async {
        do {
            try await rentalRef.document(book.rental).delete()
            print("렌탈 삭제완료")
        } catch {
            print("Error removing document: \(error)")
        }
        self.fetchRentals()
    }
    
    func getRental(_ rentalID: String) async -> Rental {
        let rentaldocRef = rentalRef.document(rentalID)
        do {
            let document = try await rentaldocRef.getDocument(as: Rental.self)
            return document
        } catch {
            print("렌탈 디코딩 에러 \(error)")
        }
        return Rental()
    }
    
    func loadRentals() async {
        do {
            let querySnapshot = try await rentalRef.getDocuments()
            DispatchQueue.main.sync {
                rentals = querySnapshot.documents.compactMap { document -> Rental? in
                    do {
                        let rental = try document.data(as: Rental.self)
                        return rental
                    } catch {
                        print("Error decoding rental: \(error)")
                        return nil
                    }
                }
            }
        } catch {
            print("Error fetching documents: \(error)")
        }
    }
    
    /// 사용자가 대여한 모든 렌탈을 필터링하는 함수
    func filterByBorrowerID(_ borrowerID: String) -> [Rental] {
        return rentals.filter { $0.bookBorrower == borrowerID }
    }
    
    func fetchRentals() {
        Task {
            await loadRentals()
        }
    }
}


