//
//  NoticeService.swift
//  BookBillionaireAdmin
//
//  Created by YUJIN JEON on 4/24/24.
//

import Foundation
import FirebaseFirestore

class NoticeService: ObservableObject {
    public var lists: [Notice] = []
    private let noticeRef = Firestore.firestore().collection("Notice")

    /// 공지사항 등록하는 함수
    func registerNotice(_ notice: Notice) {
        do {
            try noticeRef.document(notice.id).setData(from: notice)
        } catch let error {
            print("\(#function) 공지사항 저장 함수 오류: \(error)")
        }
    }
    
    func loadNotice() async {
        do {
            let querySnapshot = try await noticeRef.getDocuments()
            DispatchQueue.main.sync {
                lists = querySnapshot.documents.compactMap { document -> Notice? in
                    do {
                        let notice = try document.data(as: Notice.self)
                        return notice
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
    
    /// Notice 모두 패치
    func fetchNotice() {
        Task{
            await loadNotice()
        }
    }
}
