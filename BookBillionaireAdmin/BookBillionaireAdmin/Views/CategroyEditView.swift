//
//  CategroyEditView.swift
//  BookBillionaireAdmin
//
//  Created by YUJIN JEON on 4/24/24.
//

import SwiftUI
import BookBillionaireCore

struct CategroyEditView: View {
    @Binding var bookCategory: BookCategory
    @Binding var books: [Book]
    var gridLayout: [GridItem] = Array(repeating: .init(.flexible()), count: 4)
    var body: some View {
        VStack{
            Text("카테고리 변경 신청 목록")
            ScrollView {
                LazyVGrid(columns: gridLayout, spacing: 10) {
                    ForEach(books, id: \.self) { book in
                        GridCellInfo(book: book)
                            .padding(10)
                    }
                    .padding(5)
                }
                .padding(30)
            }
        }
        Text("변경할 카테고리 선택")
    }
}
