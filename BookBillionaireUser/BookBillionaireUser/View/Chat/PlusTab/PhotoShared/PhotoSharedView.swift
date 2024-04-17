//
//  PhotoSharedView.swift
//  BookBillionaireUser
//
//  Created by 최준영 on 4/3/24.
//

import SwiftUI
import BookBillionaireCore
import FirebaseStorage

/// firestore에서 가져와서 채팅창에 보여주는 사진 아이템
struct PhotoSharedItem: View {
    
    var message: Message
    @State private var imageUrl: URL?

    var body: some View {
            HStack(alignment: .top) {
                if let url = imageUrl {
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .frame(width: 80, height: 80)
                    } placeholder: {
                        ProgressView()
                    }
                } else {
                    Image("default")
                        .resizable()
                        .frame(width: 100, height: 120)
                        .background(Color.gray)
                }
                
                Spacer()
            }
        .onAppear {
            // 사진 받아오기
            if message.ImageURL!.hasPrefix("http://") || message.ImageURL!.hasPrefix("https://") {
                imageUrl = URL(string: message.ImageURL ?? "")
            } else {
                let storageRef = Storage.storage().reference(withPath: message.ImageURL ?? "")
                storageRef.downloadURL { (url, error) in
                    if let error = error {
                        print("사진 URL 가져오기 실패: \(error)")
                    } else if let url = url {
                        imageUrl = url
                    }
                }
            }
        }
    }
}
