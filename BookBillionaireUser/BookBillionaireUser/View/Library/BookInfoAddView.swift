//
//  BookInfoAddView.swift
//  BookBillionaireUser
//
//  Created by Woo Sung jong on 4/4/24.
//

import SwiftUI
import BookBillionaireCore
import PhotosUI

struct BookInfoAddView: View {
    @Binding var book: Book
    @State var isShowingSheet: Bool = false
    @State var isShowingDialog: Bool = false
    @State var isShowingPhotosPicker: Bool = false
    @State var isShowingCamera: Bool = false
    @Binding var selectedImage: UIImage?
    @State private var selectedItem: PhotosPickerItem?
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                if let image = selectedImage {
                    Button {
                        isShowingDialog.toggle()
                    } label: {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 100, height: 140)
                    }
                } else if let url = URL(string: book.thumbnail), !book.thumbnail.isEmpty {
                    Button {
                        isShowingDialog.toggle()
                    } label: {
                        AsyncImage(url: url) { image in
                            image.resizable()
                                .frame(width: 100, height: 140)
                        } placeholder: {
                            Image("default")
                                .resizable()
                                .frame(width: 100, height: 140)
                        }
                    }
                } else {
                    Button {
                        isShowingDialog.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .foregroundStyle(Color.white)
                            .font(.largeTitle)
                            .frame(width: 100, height: 140)
                            .background(Color.gray)
                    }
                }
                VStack(alignment: .leading) {
                    TextField("책 이름을 입력해주세요", text: $book.title)
                    TextField("작가 이름을 입력해주세요", text: Binding(
                        get: { self.book.authors.joined(separator: ",") },
                        set: { self.book.authors = $0.components(separatedBy: ",") }
                    ))
                    HStack {
                        Button {
                            isShowingSheet.toggle()
                        } label: {
                            Text("\(book.rentalState.rawValue)")
                            Image(systemName: "chevron.down")
                        }
                    }
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1))
                }
                .textFieldStyle(.roundedBorder)
            }
            .confirmationDialog("사진", isPresented: $isShowingDialog, actions: {
                Button {
                    isShowingCamera.toggle()
                } label: {
                    Text("사진 촬영")
                }
                Button {
                    isShowingPhotosPicker.toggle()
                } label: {
                    Text("사진 선택")
                }
            })
            .photosPicker(isPresented: $isShowingPhotosPicker, selection: $selectedItem)
            .onChange(of: selectedItem) { _ in
                Task {
                    if let selectedItem,
                       let data = try? await selectedItem.loadTransferable(type: Data.self) {
                        if let image = UIImage(data: data) {
                            selectedImage = image
                            book.thumbnail = "\(image)"
                        }
                    }
                }
            }
            .sheet(isPresented: $isShowingSheet) {
                RentalStateSheetView(isShowingSheet: $isShowingSheet, rentalState: $book.rentalState)
                    .presentationDetents([.fraction(0.3)])
            }
            .fullScreenCover(isPresented: $isShowingCamera) {
                CameraView(selectedImage: $selectedImage, isShowingCamera: $isShowingCamera)
            }
            .padding()
        }
    }
}

#Preview {
    BookInfoAddView(book: .constant(Book()), selectedImage: .constant(UIImage()))
}

