//
//  UploadService.swift
//  BookBillionaireAdmin
//
//  Created by YUJIN JEON on 4/28/24.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore

class UploadService : ObservableObject {
    var upLoadFile: FileTypeHtml = FileTypeHtml(type: .privatePolicy)
    /// file을 불러올때 외부 경로를 내부경로로 바꾸는 함수
    func fileAccessSecureResource(file: URL, subject: FileType) {
        do {
            let selectedFile: URL = file
            
            guard selectedFile.startAccessingSecurityScopedResource() else {
                // Handle the failure here.
                return
            }
            
            let documentsUrl =  FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
            let destinationUrl = documentsUrl.appendingPathComponent(selectedFile.lastPathComponent)
            
            if let dataFromURL = NSData(contentsOf: selectedFile) {
                if dataFromURL.write(to: destinationUrl, atomically: true) {
                    print("file saved [\(destinationUrl.path)]")
                    fileUploadToFirebase(fileURL: destinationUrl, subject: subject)
                } else {
                    print("error saving file")
                    _ = NSError(domain:"Error saving file", code:1001, userInfo:nil)
                }
            }
            
            selectedFile.stopAccessingSecurityScopedResource()
        }
    }
    /// 내부경로로 변화된 file 을 firebase에 업로드 하는 함수
    func fileUploadToFirebase(fileURL: URL, subject: FileType) {
        let storage = Storage.storage()
        let localFile = fileURL
        
        // StorageReference 인스턴스 생성
        let storageRef = storage.reference().child("\(subject.rawValue)/\(localFile.lastPathComponent)")
        storageRef.getMetadata{ (metadata, error) in
            if let error = error {
                // Uh-oh, an error occurred!
            } else {
                // Metadata is nil if the file does not exist
                if let _ = metadata {
                    return
                } else {
                    // 업로드 작업 생성
                    let uploadTask = storageRef.putFile(from: localFile, metadata: nil)
                    uploadTask.observe(.success) { snapshot in
                        snapshot.reference.downloadURL { (url, error) in
                            if let error = error {
                                print("snapshot 다운로드 에러\(error)")
                            } else {
                                let db = Firestore.firestore()
                                if subject == .termsOfUse {
                                    self.upLoadFile.type = .termsOfUse
                                } else {
                                    self.upLoadFile.type = .privatePolicy
                                }
                                self.upLoadFile.url = url
                                let docRef = db.collection(subject.rawValue).document(self.upLoadFile.id)
                                do {
                                    try docRef.setData(from: self.upLoadFile)
                                } catch {
                                    print("\(#function)  저장 함수 오류: \(error)")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
