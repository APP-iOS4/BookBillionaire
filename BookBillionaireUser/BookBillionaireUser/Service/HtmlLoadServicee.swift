//
//  HtmlLoadServicee.swift
//  BookBillionaireUser
//
//  Created by YUJIN JEON on 4/29/24.
//

import Foundation
import FirebaseFirestore
import BookBillionaireCore

class HtmlLoadServicee: ObservableObject {
    private let db = Firestore.firestore()

    func loadHtml(file: FileType) async -> [FileTypeHtml]{
        var files: [FileTypeHtml] = []
        do {
            let querySnapshot = try await db.collection(file.rawValue).getDocuments()
            DispatchQueue.main.sync {
                files = querySnapshot.documents.compactMap { document -> FileTypeHtml? in
                    do {
                        let file = try document.data(as: FileTypeHtml.self)
                        return file
                    } catch {
                        print("Error decoding book: \(error)")
                        return nil
                    }
                }
            }
        } catch {
            print("Error fetching documents: \(error)")
        }
        return files
    }
}
