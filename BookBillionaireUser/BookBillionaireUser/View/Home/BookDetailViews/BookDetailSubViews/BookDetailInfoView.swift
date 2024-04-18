//
//  BookDetailInfoView.swift
//  BookBillionaireUser
//
//  Created by 홍승표 on 4/17/24.
//

import SwiftUI
import BookBillionaireCore

struct BookDetailInfoView: View {
    let book: Book
    
    var body: some View {
        VStack(alignment: .leading){
            Text("작품소개")
                .font(.subheadline)
                .fontWeight(.bold)
            Text(book.contents)
                .font(.system(size: 13))
            
            HStack{
                if book.authors.isEmpty {
                    Text("저자를 찾을 수 없어요.")
                } else {
                    ForEach(book.authors, id: \.self) { author in
                        Text(author)
                    }
                }
                Divider()
                ForEach(book.translators ?? ["번역자"], id: \.self) { translator in Text("번역:\(translator)")
                }
                Spacer()
                Text(book.bookCategory?.rawValue ?? "카테고리")
            }
            .font(.caption)
        }
    }
}

#Preview {
    BookDetailInfoView(book: Book(ownerID: "", title: "", contents: "", authors: [""], rentalState: .rentalAvailable))
}
