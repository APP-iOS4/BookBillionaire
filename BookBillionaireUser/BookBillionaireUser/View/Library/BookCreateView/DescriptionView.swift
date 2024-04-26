//
//  DescriptionView.swift
//  BookBillionaireUser
//
//  Created by Woo Sung jong on 4/3/24.
//

import SwiftUI
import BookBillionaireCore

struct DescriptionView: View {
    @Binding var book: Book
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text("설명")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.accentColor)
                Spacer()
            }
            VStack {
                // 책 설명 입력 필드
                TextField("책에 대한 내용을 적어주세요", text: $book.contents, axis: .vertical)
                    .lineLimit(12, reservesSpace: true)
                    .onChange(of: book.contents) { newValue in
                        book.contents = checkInputLimit(newValue, limit: 300)
                    }
                    .overlay(
                        Text("\(book.contents.count) / 300")
                            .foregroundStyle(.gray)
                            .font(.caption)
                            .fontWeight(.semibold)
                        ,
                        alignment: .bottomTrailing
                    )
                    .focused($isFocused)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 15)
                .stroke(isFocused ? Color.accentColor : Color.gray, lineWidth: 2))
        }
        .padding()
    }
    
    private func checkInputLimit(_ input: String, limit: Int) -> String {
        if input.count > limit {
            return String(input.prefix(limit))
        }
        return input
    }
}

#Preview {
    DescriptionView(book: .constant(Book()))
}
