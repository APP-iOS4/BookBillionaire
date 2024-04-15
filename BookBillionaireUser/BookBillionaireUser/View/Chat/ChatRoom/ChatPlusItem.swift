//
//  ChatPlusItem.swift
//  BookBillionaireUser
//
//  Created by 최준영 on 4/7/24.
//

import SwiftUI
import PhotosUI

struct ChatPlusItem: View {
    @State private var selectedImage: UIImage?
    @State private var selectedItem: PhotosPickerItem?
    @Binding var message: Message
    var messageVM: MessageListViewModel

    var body: some View {
        HStack {
            GridRow {
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    VStack{
                        ZStack {
                            RoundedRectangle(cornerSize: CGSize(width: 5, height: 5))
                                .foregroundColor(.accent)
                            Image(systemName: "photo.fill")
                                .foregroundColor(.white)
                        }
                        .frame(width: 50, height: 40)
                        
                        Text("사진보내기")
                            .foregroundStyle(.gray)
                    }
                }
            }
            .onChange(of: selectedItem) { _ in
                Task {
                    if let selectedItem,
                       let data = try? await selectedItem.loadTransferable(type: Data.self) {
                        if let image = UIImage(data: data) {
                            selectedImage = image
                            message.ImageURL = "\(image)"
                            messageVM.uploadPhoto(selectedImage: selectedImage, photoImage: message.ImageURL ?? "")
                            print(message.ImageURL!)
                        }
                    }
                }
            }
            .padding(.trailing, 40)
            
            GridRow {
                Button {
                    // 맵 뷰로 이동
                } label: {
                    VStack {
                        ZStack {
                            RoundedRectangle(cornerSize: CGSize(width: 5, height: 5))
                                .foregroundColor(.gray)
                            Image(systemName: "map")                    .foregroundColor(.white)
                        }
                        .frame(width: 50, height: 40)
                        
                        Text("약속장소")
                            .foregroundStyle(.gray)
                    }
                }
            }
            .padding(.trailing, 40)
            
            GridRow {
                Button {
                    // 신고 뷰로 이동
                } label: {
                    VStack {
                        ZStack {
                            RoundedRectangle(cornerSize: CGSize(width: 5, height: 5))
                                .foregroundColor(.red)
                            Image(systemName: "light.beacon.max.fill")                    .foregroundColor(.white)
                        }
                        .frame(width: 50, height: 40)
                        
                        Text("신고하기")
                            .foregroundStyle(.gray)
                    }
                }
            }
        }
    }
}


//#Preview {
//    ChatPlusItem()
//}
