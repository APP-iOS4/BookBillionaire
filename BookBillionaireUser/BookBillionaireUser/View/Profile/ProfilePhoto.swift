//
// ProfilePhoto.swift
// BookBillionaireUser
//
// Created by Woo Sung jong on 4/15/24.
//

import SwiftUI
import BookBillionaireCore
import FirebaseStorage

struct ProfilePhoto: View {
    let user: User
    @State private var imageUrl: URL?
    @Binding var selectedImage: UIImage?
    
    var body: some View {
        Group {
            // 프로필 이미지
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
            } else if let url = imageUrl {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                } placeholder: {
                    Image("defaultUser1")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                }
            } else {
                Image("defaultUser1")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
            }
        }
        .onAppear {
            // Firebase Storage 경로 URL로 다운로드
            let storageRef = Storage.storage().reference(withPath: user.image ?? "profile/defaultUser")
            storageRef.downloadURL { (url, error) in
                if let error = error {
                    print("Error getting download URL: \(error)")
                } else if let url = url {
                    imageUrl = url
                }
            }
        }
    }
}

#Preview {
    ProfilePhoto(user: User(), selectedImage: .constant(UIImage(named: "defaultUser1")))
}
