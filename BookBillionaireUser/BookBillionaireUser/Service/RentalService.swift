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
    
    func deleteRental(_ rental: Rental) async {
        do {
            try await rentalRef.document(rental.id).delete()
            print("렌탈 삭제 완료")
        } catch {
            print("\(#function) Error removing document : \(error)")
        }
    }
    
    func updateRental(_ rentalID: String, rentalTime: Date) async {
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
    
    
    func getRental(_ rentalID: String) async -> Rental {
        let rentaldocRef = rentalRef.document(rentalID)
        do {
            return try await rentaldocRef.getDocument(as: Rental.self)
        } catch {
            print("렌탈 디코딩 에러 \(error)")
        }
        return Rental()
    }
}


