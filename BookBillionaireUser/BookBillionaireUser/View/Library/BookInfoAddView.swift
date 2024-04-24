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
    @State private var isShowingSheet: Bool = false
    @State private var isShowingDialog: Bool = false
    @State private var isShowingPhotosPicker: Bool = false
    @State private var isShowingCamera: Bool = false
    @Binding var selectedImage: UIImage?
    @State private var selectedItem: PhotosPickerItem?
    @State private var isShowingAlert: Bool = false
    @FocusState private var isTitleFocused: Bool
    @FocusState private var isAuthorFocused: Bool
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                // 책 이미지
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
                    // 책 이름 입력 필드
                    TextField("책 이름을 입력해주세요", text: $book.title)
                        .onChange(of: book.title) { newValue in
                            let limitedText = checkInputLimit(newValue, limit: 100)
                            if book.title != limitedText {
                                book.title = limitedText
                                isShowingAlert = true
                            }
                        }
                        .padding(10)
                        .focused($isTitleFocused)
                        .background(RoundedRectangle(cornerRadius: 5)
                            .stroke(isTitleFocused ? Color.accentColor : Color.gray.opacity(0.2), lineWidth: 2))
                    // 작가 이름 입력 필드
                    TextField("작가 이름을 입력해주세요", text: Binding(
                        get: { self.book.authors.joined(separator: ",") },
                        set: { self.book.authors = $0.components(separatedBy: ",") }
                    ))
                    .onChange(of: book.authors.joined(separator: ",")) { newValue in
                        let authorsText = book.authors.joined(separator: ",")
                        let limitedText = checkInputLimit(newValue, limit: 50)
                        if authorsText != limitedText {
                            book.authors = [limitedText]
                            isShowingAlert = true
                        }
                    }
                    .padding(10)
                    .focused($isAuthorFocused)
                    .background(RoundedRectangle(cornerRadius: 5)
                        .stroke(isAuthorFocused ? Color.accentColor : Color.gray.opacity(0.2), lineWidth: 2))
                    // 대여 상태 선택
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
            }
            // 다이얼로그
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
            // 알럿
            .alert("입력 제한 초과", isPresented: $isShowingAlert) {
                Button(role: .cancel) {
                    
                } label: {
                    Text("확인")
                }
            } message: {
                Text("입력한 내용이 제한 길이를 초과했습니다. 초과된 내용은 자동으로 삭제됩니다.")
            }
            // 사진 선택
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
            // 대여 상태 시트
            .sheet(isPresented: $isShowingSheet) {
                RentalStateSheetView(isShowingSheet: $isShowingSheet, rentalState: $book.rentalState)
                    .presentationDetents([.fraction(0.3)])
            }
            // 사진 촬영 풀스크린커버
            .fullScreenCover(isPresented: $isShowingCamera) {
                CameraView(selectedImage: $selectedImage, isShowingCamera: $isShowingCamera)
            }
            .padding()
        }
    }
    
    private func checkInputLimit(_ input: String, limit: Int) -> String {
        if input.count > limit {
            return String(input.prefix(limit))
        }
        return input
    }
}

#Preview {
    BookInfoAddView(book: .constant(Book()), selectedImage: .constant(UIImage(resource: .default)))
}

