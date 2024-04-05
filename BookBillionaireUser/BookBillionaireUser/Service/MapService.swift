//
//  MapService.swift
//  BookBillionaireUser
//
//  Created by YUJIN JEON on 4/5/24.
//

import Foundation
import FirebaseFirestore
import BookBillionaireCore

class MapService: ObservableObject {
    static let shared = MapService() // 싱글턴 인스턴스
    private let mapRef = Firestore.firestore().collection("maps")
    
    private init() {
    } // 외부에서 인스턴스화 방지를 위한 private 초기화
    
    /// 위치를 등록하는 함수
    func registerMap(_ map: Map) -> Bool {
        do {
            try mapRef.document(map.id).setData(from: map)
            return true
        } catch let error {
            print("\(#function) Map 저장 함수 오류: \(error)")
            return false
        }
    }
}
