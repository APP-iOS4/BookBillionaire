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
            Text("📖 기본 정보")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.bottom, 5)
            
            Text("책 소개")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
                .padding(.bottom, 3)
            Text(book.contents)
                .lineSpacing(5)
                .font(.caption)
            Divider()
                .padding(.vertical, 10)
            
            VStack(alignment: .leading) {
                Text("저자 및 역자")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                    .padding(.bottom, 5)
                
                HStack(alignment: .center){
                    if book.authors.isEmpty {
                        Text("저자를 찾을 수 없어요.")
                    } else {
                        // 작가가 여러명일수도 있어서 ForEach
                        ForEach(book.authors, id: \.self) { author in
                            Text("\(author)")
                        }
                    }
                    // 번역자도 여러명일수도 있어서 ForEach
                    if let translators = book.translators, !translators.isEmpty {
                        // 번역자가 있으면 표시
                        ForEach(translators, id: \.self) { translator in
                            Text("옮긴이: \(translator)")
                        }
                    }
                }
            }
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .font(.caption)
            .padding(.bottom, 10)
            
            Text("카테고리")
                .font(.subheadline)
                .fontWeight(.bold)
                .padding(.bottom, 5)
            Text(book.bookCategory?.rawValue ?? "카테고리")
                .font(.caption)
          
        }
    }
}

#Preview {
    BookDetailInfoView(book: Book(ownerID: "", title: "", contents: "", authors: [""], rentalState: .rentalAvailable))
}
