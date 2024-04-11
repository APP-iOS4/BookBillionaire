//
//  BookDetailImageView.swift
//  BookBillionaireUser
//
//  Created by 홍승표 on 4/11/24.
//

import SwiftUI
import BookBillionaireCore

struct BookDetailImageView: View {
    let book: Book
    
    var body: some View {
        ZStack{
                AsyncImage(url: URL(string: book.thumbnail)){ image in
                    image.resizable(resizingMode: .stretch)
                        .ignoresSafeArea()
                        .blur(radius: 8.0,opaque: true)
                } placeholder: {
                    Rectangle().background(.black)
                }
                .background(Color.gray)
      
            VStack(alignment: .center){
                    UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 25.0, topTrailing: 25.0))
                        .frame(height: 100)
                        .foregroundStyle(Color.white)
                        .padding(.top, 200)
                }
            
            GeometryReader { geometry in
                AsyncImage(url: URL(string: book.thumbnail)){ image in
                    image.resizable()
                        .ignoresSafeArea()
                        .frame(width: 200)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 1.5)
            }
        }
    }
}

#Preview {
    BookDetailImageView(book: Book(owenerID: "", title: "책제목", contents: "책내용", authors: ["작가"], rentalState: .rentalAvailable))
}
