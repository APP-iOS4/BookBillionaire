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
    static let shared = RentalService() // 싱글턴 인스턴스
    private let rentalRef = Firestore.firestore().collection("rentals")
    
    private init() {
    } // 외부에서 인스턴스화 방지를 위한 private 초기화
    
    /// 약속일정을 잡을 때 등록하는 함수
    func registerRental(_ rental: Rental) -> Bool {
        do {
            try rentalRef.document(rental.id).setData(from: rental)
            return true
        } catch let error {
            print("\(#function) 렌탈 저장 함수 오류: \(error)")
            return false
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
}
