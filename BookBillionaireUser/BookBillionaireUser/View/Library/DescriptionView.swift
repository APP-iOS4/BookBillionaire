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
    @State var descriptionText: String = ""
    
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
                TextField("책에 대한 내용을 적어주세요", text: $book.contents, axis: .vertical)
                    .lineLimit(10, reservesSpace: true)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 15)
                .stroke(Color.accentColor, lineWidth: 2))
        }
        .padding()
    }
}

#Preview {
    DescriptionView(book: .constant(Book.sample))
}
