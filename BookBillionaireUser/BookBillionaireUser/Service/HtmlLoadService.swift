//
//  HtmlLoadServicee.swift
//  BookBillionaireUser
//
//  Created by YUJIN JEON on 4/29/24.
//

import Foundation
import FirebaseFirestore
import BookBillionaireCore

class HtmlLoadService: ObservableObject {
    @Published var privatePolicy: [FileTypeHtml] = []
    @Published var termsOfUse: [FileTypeHtml] = []
    
    private let db = Firestore.firestore()

    func loadHtml(file: FileType) async {
        var files: [FileTypeHtml] = []
        do {
            let querySnapshot = try await db.collection(file.rawValue).getDocuments()
            DispatchQueue.main.sync {
                files = querySnapshot.documents.compactMap { document -> FileTypeHtml? in
                    do {
                        let file = try document.data(as: FileTypeHtml.self)
                        return file
                    } catch {
                        print("Error decoding HtmlFile: \(error)")
                        return nil
                    }
                }
                if file == .privatePolicy { self.privatePolicy = files } else { self.termsOfUse = files }
            }
        } catch {
            print("Error fetching documents: \(error)")
        }
    }
    
    func fetchAllDocs() async {
        await self.loadHtml(file: .privatePolicy)
        await self.loadHtml(file: .termsOfUse)
    }
}
