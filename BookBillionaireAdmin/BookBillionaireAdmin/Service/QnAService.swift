//
//  QnAService.swift
//  BookBillionaireAdmin
//
//  Created by YUJIN JEON on 4/24/24.
//

import Foundation
import FirebaseFirestore

class QnAService: ObservableObject {
    public var lists: [QnA] = []
    private let qnaRef = Firestore.firestore().collection("QnA")

    /// QnA 등록하는 함수
    func registerQnA(_ qna: QnA) {
        do {
            try qnaRef.document(qna.id).setData(from: qna)
        } catch let error {
            print("\(#function) QnA 저장 함수 오류: \(error)")
        }
    }
    
    /// QnA 로드하는 함수
    func loadQnas() async {
        do {
            let querySnapshot = try await qnaRef.getDocuments()
            DispatchQueue.main.sync {
                lists = querySnapshot.documents.compactMap { document -> QnA? in
                    do {
                        let qna = try document.data(as: QnA.self)
                        return qna
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
    
    /// QnA 모두 패치
    func fetchQnA() {
        Task{
            await loadQnas()
        }
    }
}
