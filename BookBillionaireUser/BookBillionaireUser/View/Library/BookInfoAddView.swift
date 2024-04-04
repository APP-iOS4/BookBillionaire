//
//  BookInfoAddView.swift
//  BookBillionaireUser
//
//  Created by Woo Sung jong on 4/4/24.
//

import SwiftUI
import BookBillionaireCore

struct BookInfoAddView: View {
    @State var book: Book = Book.sample
    @State var isShowingSheet: Bool = false
    @State var isShowingPhoto: Bool = false
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                if book.thumbnail.isEmpty {
                    Button {
                        isShowingPhoto.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .foregroundStyle(Color.white)
                            .font(.largeTitle)
                            .frame(width: 100, height: 140)
                            .background(Color.gray)
                    }
                } else {
                    AsyncImage(url: URL(string: book.thumbnail)) { image in
                        image.resizable()
                            .frame(width: 100, height: 140)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 100, height: 140)
                    }
                }
                VStack(alignment: .leading) {
                    TextField("책 이름을 입력해주세요", text: $book.title)
                    TextField("작가 이름을 입력해주세요", text: $book.authors[0])
                    HStack {
                        Button {
                            isShowingSheet.toggle()
                        } label: {
                            Text("\(book.rentalState.description)")
                            Image(systemName: "chevron.down")
                        }
                    }
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1))
                }
                .textFieldStyle(.roundedBorder)
            }
            .confirmationDialog("사진", isPresented: $isShowingPhoto, actions: {
                Button {
                    
                } label: {
                    Text("사진 촬영")
                }
                
                Button {
                    
                } label: {
                    Text("사진 선택")
                }
            })
            .sheet(isPresented: $isShowingSheet) {
                RentalStateSheetView(isShowingSheet: $isShowingSheet, rentalState: $book.rentalState)
                    .presentationDetents([.medium])
            }
            .padding()
        }
    }
}

#Preview {
    BookInfoAddView()
}
