//
//  ChatPlusItem.swift
//  BookBillionaireUser
//
//  Created by 최준영 on 4/7/24.
//

import SwiftUI
import PhotosUI
import FirebaseStorage

struct ChatPlusItem: View {
    @State private var selectedImage: UIImage?
    @State private var image: String?
    @State private var selectedItem: PhotosPickerItem?
    @State private var isShowingPhotosPicker: Bool = false

    @Binding var message: Message
    @Binding var chatImageURL: URL?
    @Environment(\.colorScheme) var colorScheme

    var messageVM: MessageListViewModel
    var path: String?

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
                            .foregroundColor(colorScheme == .dark ? .white : .gray)
                    }
                }
            }
            .onChange(of: selectedItem) { _ in
                Task {
                    if let selectedItem,
                       let data = try? await selectedItem.loadTransferable(type: Data.self) {
                        if let image = UIImage(data: data) {
                            selectedImage = image
                            
                            messageVM.uploadPhoto(selectedImage: selectedImage) { imageURL in
                                if let imageURL = imageURL {
                                    print("업로드 이미지 URL 받아오기 성공: \(imageURL) 🎉")
                                    self.chatImageURL = imageURL
                                } else {
                                    // 이미지 업로드에 실패한 경우 또는 다운로드 URL을 가져오는 데 실패한 경우
                                    print("업로드 이미지 URL 다운로드를 실패했습니다 🥲")
                                }
                            }
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
                            .foregroundColor(colorScheme == .dark ? .white : .gray)
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
                            .foregroundColor(colorScheme == .dark ? .white : .gray)
                    }
                }
            }
        }
    }
}


//#Preview {
//    ChatPlusItem()
//}
